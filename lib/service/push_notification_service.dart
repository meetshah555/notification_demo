import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app/app_routes.dart';

class PushNotificationService extends GetxService {
  // Firebase Messaging instance for handling FCM
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Plugin instance to show local notifications
  static final FlutterLocalNotificationsPlugin _flutterLocalNotifications =
  FlutterLocalNotificationsPlugin();

  // Android notification channel for high importance notifications
  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.max,
  );

  // Observable FCM token for binding and UI access
  final RxString fcmToken = ''.obs;

  // RemoteMessage received when the app was terminated and launched via a notification tap
  RemoteMessage? initialMessage;

  /// Initializes the push notification service
  Future<PushNotificationService> init() async {
    // Request notification permissions (especially for iOS and Android 13+)
    await _requestPermissions();

    // Setup local notification channels and listeners
    await _setupLocalNotification();

    // Get the FCM token used to target this specific device
    fcmToken.value = await _fcm.getToken() ?? 'Unable to get token';
    debugPrint("TOKEN VALUE ::::: ${fcmToken.value}");

    // Listen for messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background or foreground
    FirebaseMessaging.onMessageOpenedApp.listen(handleTapMessage);

    // Get the message that caused the app to open from a terminated state
    initialMessage = await _fcm.getInitialMessage();

    return this;
  }

  /// Requests notification permissions for both Android and iOS platforms
  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _fcm.requestPermission(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      // Android 13+ requires runtime notification permission
      if (sdkInt >= 33) {
        final status = await Permission.notification.status;
        if (!status.isGranted) {
          await Permission.notification.request();
        }
      }
    }
  }

  /// Sets up local notifications (channel, initialization, click behavior)
  Future<void> _setupLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    await _flutterLocalNotifications.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) {
          // Handle local notification tap: redirecting to verification screen
          Get.toNamed(AppRoutes.verifyMobileScreen, arguments: payload);
        }
      },
    );

    // Create the Android channel for displaying notifications
    if (Platform.isAndroid) {
      await _flutterLocalNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);
    }
  }

  /// Handles foreground notifications by showing them manually
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    debugPrint('🔔 Foreground notification: ${message.data['mydata1']}');
    debugPrint('🔔 Foreground notification: ${message.data['mydata2']}');

    if (notification != null) {
      final android = AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      final ios = const DarwinNotificationDetails();

      final platform = NotificationDetails(android: android, iOS: ios);

      // Show local notification while app is in foreground
      _flutterLocalNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platform,
      );
    }
  }

  /// Handles background data-only messages and shows a local notification
  static void handleBackgroundMessage(RemoteMessage message) {
    final notification = message.data;

    if (notification.isNotEmpty) {
      final android = AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      final ios = const DarwinNotificationDetails();

      final platform = NotificationDetails(android: android, iOS: ios);

      // Show local notification from data payload (when app is in background/terminated)
      _flutterLocalNotifications.show(
        notification.hashCode,
        notification['title'],
        notification['body'],
        platform,
      );
    }
  }

  /// Handles notification taps (navigates to a specific screen)
  void handleTapMessage(RemoteMessage message, {bool? fromTerminated = false}) {
    debugPrint('🔔 Tapped notification: ${message.notification?.title}');
    debugPrint('🔔 Tapped notification: ${message.data['mydata1']}');
    debugPrint('🔔 Tapped notification: ${message.data['mydata2']}');

    // Navigate after a slight delay to avoid transition glitches
    Future.delayed(
      Duration(milliseconds: 300),
          () => fromTerminated == true
          ? Get.offNamed(AppRoutes.verifyMobileScreen, arguments: message)
          : Get.toNamed(AppRoutes.verifyMobileScreen, arguments: message),
    );
  }

  /// Returns the device's FCM token
  static Future<String?> getFcmToken() => _fcm.getToken();
}

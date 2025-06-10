import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app/app_routes.dart';

class PushNotificationService extends GetxService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotifications = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.max,
  );

  final RxString fcmToken = ''.obs;

  RemoteMessage? initialMessage;

  Future<PushNotificationService> init() async {
    // iOS foreground permission
    await _requestPermissions();

    await _setupLocalNotification();

    fcmToken.value = await _fcm.getToken() ?? 'Unable to get token';
    debugPrint("TOKEN VALUE ::::: ${fcmToken.value}");

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleTapMessage);

    initialMessage = await _fcm.getInitialMessage();

    return this;
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _fcm.requestPermission(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (sdkInt >= 33) {
        final status = await Permission.notification.status;
        if (!status.isGranted) {
          await Permission.notification.request();
        }
      }
    }
  }

  Future<void> _setupLocalNotification() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    await _flutterLocalNotifications.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null) {
          // TODO HANDLE NAVIGATION ACCORDINGLY FOR NOW I AM REDIRECTING IT TO VERIFICATION SCREEN
          Get.toNamed(AppRoutes.verifyMobileScreen);
        }
      },
    );

    if (Platform.isAndroid) {
      await _flutterLocalNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
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

      _flutterLocalNotifications.show(notification.hashCode, notification.title, notification.body, platform);
    }
  }

  void handleTapMessage(RemoteMessage message, {bool? fromTerminated = false}) {
    debugPrint('🔔 Tapped notification: ${message.notification?.title}');
    // TODO HANDLE NAVIGATION ACCORDINGLY FOR NOW I AM REDIRECTING IT TO VERIFICATION SCREEN
    // Add delay for smooth screen transitions - prevents jerky navigation
    // when app is initializing from background state
    Future.delayed(
      Duration(milliseconds: 300),
      () => fromTerminated == true ? Get.offNamed(AppRoutes.verifyMobileScreen) : Get.toNamed(AppRoutes.verifyMobileScreen),
    );
  }

  static Future<String?> getFcmToken() => _fcm.getToken();
}

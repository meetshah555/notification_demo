import 'package:get/get.dart';

import '../../../app/app_routes.dart';
import '../../../service/push_notification_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    navigateToNextScreen();
    super.onInit();
  }

  Future<void> navigateToNextScreen() async {
    final pushService = Get.find<PushNotificationService>();
    if (pushService.initialMessage != null) {
      Future.microtask(() {
        pushService.handleTapMessage(pushService.initialMessage!, fromTerminated: true);
        pushService.initialMessage = null; // Clear after handling
      });
    } else {
      Future.delayed(Duration(seconds: 3), () => Get.offNamed(AppRoutes.loginPage));
    }
  }

  // App is up to date or user skipped optional update
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app_routes.dart';

class VerifyMobileController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  void gotoVerificationSuccess() {
    // TODO Continue Navigation of the app from here for now i am navigating to login again for developement
    Get.toNamed(AppRoutes.loginPage);
  }


  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}

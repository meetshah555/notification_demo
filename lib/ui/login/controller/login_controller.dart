import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app_routes.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void validateAndLogin() async {
    Get.toNamed(AppRoutes.verifyMobileScreen);
  }
}

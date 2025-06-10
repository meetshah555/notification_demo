import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/login/binding/login_binidng.dart';
import '../ui/login/view/login_page.dart';
import '../ui/splash/binding/splash_binding.dart';
import '../ui/splash/view/splash_screen.dart';
import '../ui/verify_mobile/binding/verify_mobile_binding.dart';
import '../ui/verify_mobile/view/verify_mobile_screen.dart';

/// All routes for app pages are defined here
class AppRoutes {
  static const initialRoute = '/';
  static const loginPage = '/loginPage';

  static const verifyMobileScreen = '/verify_mobile_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    const transition = Transition.rightToLeft;
    const duration = Duration(milliseconds: 350);

    switch (settings.name) {
      case AppRoutes.initialRoute:
        return GetPageRoute(
          routeName: AppRoutes.initialRoute,
          page: () => const SplashPage(),
          binding: SplashBinding(),
          settings: settings,
          transition: transition,
          transitionDuration: duration,
        );

      case AppRoutes.loginPage:
        return GetPageRoute(
          routeName: AppRoutes.loginPage,
          page: () => const LoginPage(),
          binding: LoginBinding(),
          settings: settings,
          transition: transition,
          transitionDuration: duration,
        );

      case AppRoutes.verifyMobileScreen:
        return GetPageRoute(
          routeName: AppRoutes.verifyMobileScreen,
          page: () => const VerifyMobileScreen(),
          binding: VerifyMobileBinding(),
          settings: settings,
          transitionDuration: duration,
          transition: Transition.leftToRight,
        );

      default:
        return GetPageRoute(
          page: () => Scaffold(body: Center(child: Text("Undefined route"))),
          transition: transition,
          transitionDuration: duration,
        );
    }
  }
}

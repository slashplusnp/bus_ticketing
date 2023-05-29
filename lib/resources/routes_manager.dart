import 'package:flutter/material.dart' show Widget, RouteSettings, Scaffold, AppBar, Text, Route, MaterialPageRoute;

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/splash_page.dart';
import 'string_manager.dart';

enum Routes {
  splash('/'),
  login('/login'),
  home('/home'),
  ;

  final String name;
  const Routes(this.name);

  static Routes fromName(String name) {
    return Routes.values.firstWhere((route) => route.name == name);
  }

  static Widget _getWidget(RouteSettings routeSettings) {
    final routeSettingsName = routeSettings.name;

    if (routeSettingsName == null) return undefinedRoute();

    // final args = routeSettings.arguments;

    switch (Routes.fromName(routeSettingsName)) {
      case Routes.splash:
        return const SplashPage();
      case Routes.login:
        return const LoginPage();
      case Routes.home:
        return const HomePage();
    }
  }

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(builder: (context) => _getWidget(routeSettings));
  }

  static Widget undefinedRoute() {
    return Scaffold(
      appBar: AppBar(
        title: AppBar(
          title: const Text(AppString.noRouteFound),
        ),
      ),
    );
  }
}

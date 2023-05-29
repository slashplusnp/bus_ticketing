import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../resources/routes_manager.dart';
import '../resources/theme_managar.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeManager.getAppTheme(),
          initialRoute: Routes.splash.name,
          onGenerateRoute: Routes.getRoute,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: const ScrollBehaviorModified(),
              child: child ?? Container(),
            );
          },
        );
      },
    );
  }
}

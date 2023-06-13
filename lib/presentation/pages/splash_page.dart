import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../data/hive/hive_utils.dart';
import '../../data/responses/hardware_data/hardware_data_response.dart';
import '../../extensions/build_context_extensions.dart';
import '../../resources/hive_box_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/string_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(
        const Duration(seconds: AppDefaults.splashSec),
        () {
          final hasUserData = HiveUtils.getFromObjectBox<HardwareData>(boxName: HiveBoxManager.hardwareDataBox) != null;
          final navigatorRoute = hasUserData ? Routes.home.routeName : Routes.login.routeName;

          context.navigator.pushNamedAndRemoveUntil(
            navigatorRoute,
            (route) => false,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(AppString.splashMessage),
      ),
    );
  }
}

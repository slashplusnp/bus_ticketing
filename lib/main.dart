import 'package:bus_ticketing/app/root_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/dependency_injection.dart';
import 'data/hive/hive_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveUtils.initHiveFlutter();
  HiveUtils.registerAdapters();

  await HiveUtils.openBoxes();

  DependencyInjection.initAppModule();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const RootApp();
  }
}

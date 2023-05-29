import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/dependency_injection.dart';
import 'app/root_app.dart';
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

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const RootApp();
  }
}

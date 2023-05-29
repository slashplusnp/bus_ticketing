import 'package:hive_flutter/hive_flutter.dart';

import '../../resources/hive_box_manager.dart';
import '../responses/hardware_data/hardware_data_response.dart';

class HiveUtils {
  const HiveUtils._internal();
  static const _instance = HiveUtils._internal();
  factory HiveUtils() => _instance;

  static Future<void> initHiveFlutter() async => Hive.initFlutter();

  static void registerAdapters() {
    Hive.registerAdapter(HardwareDataAdapter()); // 0
  }

  static Future<void> openBoxes() async {
    await Hive.openBox<dynamic>(HiveBoxManager.settingsBox);
    await Hive.openBox<HardwareData>(HiveBoxManager.hardwareDataBox);
  }

  static void storeToBox<T>({
    required String boxName,
    required String boxKey,
    required T boxValue,
  }) {
    final box = Hive.box<dynamic>(boxName);
    box.put(boxKey, boxValue);
  }

  static T? getFromBox<T>({
    required String boxName,
    required String boxKey,
  }) {
    final box = Hive.box<dynamic>(boxName);
    return box.get(boxKey) as T?;
  }

  static void storeToObjectBox<T>({required String boxName, required T boxModel}) {
    final box = Hive.box<T>(boxName);
    box.add(boxModel);
  }

  static T? getFromObjectBox<T>({
    required String boxName,
  }) {
    final box = Hive.box<T>(boxName);
    if (box.isEmpty) return null;
    return box.values.last;
  }

  static void clearBox<T>({required String boxName}) {
    final box = Hive.box<T>(boxName);
    box.clear();
  }

  static String? getToken() {
    final box = Hive.box<HardwareData>(HiveBoxManager.hardwareDataBox);
    if (box.isEmpty) return null;
    final data = box.values.last;
    return data.token;
  }
}

import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../extensions/extensions.dart';
import '../../resources/hive_box_manager.dart';
import '../requests/ticket_report/ticket_report_request.dart';
import '../responses/hardware_data/hardware_data_response.dart';
import '../responses/ticket_category/ticket_category_response.dart';

class HiveUtils {
  const HiveUtils._internal();
  static const _instance = HiveUtils._internal();
  factory HiveUtils() => _instance;

  static Future<void> initHiveFlutter() async => Hive.initFlutter();

  static void registerAdapters() {
    Hive.registerAdapter(HardwareDataAdapter()); // 0
    Hive.registerAdapter(TicketCategoryAdapter()); // 1
    Hive.registerAdapter(ReportTicketCategoryAdapter()); // 2
    Hive.registerAdapter(TicketReportRequestAdapter()); // 3
  }

  static Future<void> openBoxes() async {
    await Hive.openBox<dynamic>(HiveBoxManager.settingsBox);
    await Hive.openBox<int>(HiveBoxManager.todayTotalBox);
    await Hive.openBox<int>(HiveBoxManager.tripCountBox);
    await Hive.openBox<HardwareData>(HiveBoxManager.hardwareDataBox);
    await Hive.openBox<TicketCategory>(HiveBoxManager.ticketCategoryBox);
    await Hive.openBox<ReportTicketCategory>(HiveBoxManager.reportTicketCategoryBox);
    await Hive.openBox<TicketReportRequest>(HiveBoxManager.ticketReportRequestBox);
  }

  static int getTodayTripCount() {
    final tripCountBox = Hive.box<int>(HiveBoxManager.tripCountBox);
    final todayKey = DateTime.now().toyMd();
    final todayCount = tripCountBox.get(todayKey);
    log('initial: $todayCount');
    return todayCount.orValue(1);
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

  static void updateBox<T>(String boxName, {required List<T> data}) {
    final box = Hive.box<T>(boxName);

    final values = box.values.toList();
    final isSame = const DeepCollectionEquality().equals(data, values);

    if (!isSame) {
      box.clear();
      box.addAll(data);
    }
  }

  static ValueListenable<Box<T>> getBoxListenable<T>({required String boxName}) {
    return Hive.box<T>(boxName).listenable();
  }
}

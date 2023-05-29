import 'package:flutter/material.dart' show Color;

import '../app/constants.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    assert(hexString.replaceAll('#', '').length == 6 || hexString.replaceAll('#', '').length == 8);

    hexString = hexString.replaceAll('#', '');
    if (hexString.length == 6) hexString = 'FF$hexString';

    return Color(int.parse(hexString, radix: 16));
  }
}

extension NonNullString on String? {
  String orEmpty() => this ?? Constants.emptyString;
  String orValue(String value) => this ?? value;

  String orEmptyDashed() => this ?? Constants.emptyDashedString;

  String toValueOrEmpty(String value) => this ?? value;

  DateTime? toDateTime() => DateTime.tryParse(orEmpty());

  int toIntOrZero() => int.parse(this ?? '0');
  int toIntOrValue(int value) => int.parse(this ?? '$value');
  double toDoubleOrZero() => double.parse(this ?? '0');
  double toDoubleOrValue(double value) => double.tryParse(orEmpty()) ?? value;
}

extension NonNullInt on int? {
  int orZero() => this ?? Constants.orZero;
}

extension NonNullDouble on double? {
  double orZero() => this ?? Constants.orZeroDouble;
  double orValue(double value) => this ?? value;
  bool isNotNull() => this != null;
  bool isNull() => this == null;
}

extension NonNullBool on bool? {
  bool orTrue() => this ?? true;
  bool orFalse() => this ?? false;
}

extension NonNullList<T> on List<T>? {
  List<T> orEmpty() => this ?? <T>[];
}

extension FormatDatetime on DateTime? {
  DateTime? addYear(int year) => this == null ? null : DateTime(this!.year + year, this!.month, this!.day);
}

import 'package:flutter/material.dart';

import '../app/constants.dart';
import 'color_manager.dart';
import 'font_manager.dart';

class ThemeManager {
  static ThemeData getAppTheme() {
    final themeData = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorManager.primary,
        brightness: Brightness.light,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorManager.primary,
      ),
      filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppDefaults.contentBorderRadius),
              ),
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDefaults.contentBorderRadius),
            ),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStatePropertyAll(ColorManager.primary),
        checkColor: MaterialStatePropertyAll(ColorManager.background),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: MaterialStatePropertyAll(ColorManager.foreground),
          visualDensity: VisualDensity.compact,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          iconColor: ColorManager.background,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          floatingLabelStyle: TextStyle(color: ColorManager.foreground),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: ColorManager.background,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        helperStyle: TextStyle(color: ColorManager.primary, fontSize: FontSize.fs10),
        isDense: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppDefaults.contentBorderRadius),
          ),
        ),
      ),
    );

    return themeData;
  }
}

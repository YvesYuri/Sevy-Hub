import 'package:flutter/material.dart';

class LightTheme {
  static const Color transparentColor = Color(0x00000000);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color yellow500Color = Color(0xFFF0C453);
  static const Color yellow800Color = Color(0xFFF5B616);
  static const Color gray100Color = Color(0xFFEEEEEC);
  static const Color gray200Color = Color(0xFFE0E0DC);
  static const Color gray300Color = Color(0xFF3C3C34);
  static const Color gray400Color = Color(0xFF828278);
  static const Color gray800Color = Color(0xFF1F1F1A);
  static const Color gray900Color = Color(0xFF252522);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: yellow500Color,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: gray100Color,
      fontFamily: 'Inter',
      splashColor: whiteColor.withValues(alpha: 0.1),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(gray200Color),
        checkColor: WidgetStateProperty.all(yellow800Color),
        splashRadius: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gray200Color,
        hintStyle: TextStyle(
          color: gray400Color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: yellow800Color, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        hoverColor: gray200Color,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: gray100Color,
        // elevation: 12,
        useIndicator: false,
        selectedIconTheme: IconThemeData(color: yellow500Color, size: 20),
        unselectedIconTheme: IconThemeData(color: gray400Color, size: 20),
        selectedLabelTextStyle: TextStyle(
          color: gray900Color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
        unselectedLabelTextStyle: TextStyle(
          color: gray400Color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        labelType: NavigationRailLabelType.none,
      ),
    );
  }
}

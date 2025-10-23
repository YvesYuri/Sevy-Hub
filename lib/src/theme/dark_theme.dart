import 'package:flutter/material.dart';

class DarkTheme {
  static const Color transparentColor = Color(0x00000000);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color yellow500Color = Color(0xFFF0C453);
  static const Color yellow800Color = Color(0xFFF5B616);
  static const Color gray100Color = Color(0xFFE6E6E1);
  static const Color gray200Color = Color(0xFFCCCCC4);
  static const Color gray400Color = Color(0xFF8A8A7C);
  static const Color gray800Color = Color(0xFF242420);
  static const Color gray850Color = Color(0xFF191916);
  static const Color gray900Color = Color(0xFF141412);
  static const Color errorColor = Color(0xFFF51616);
  static const Color successColor = Color(0xFF36F516);

  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: yellow500Color,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: gray900Color,
      appBarTheme: const AppBarTheme(
        backgroundColor: transparentColor,
        foregroundColor: gray100Color,
        elevation: 0,
      ),
      splashColor: whiteColor.withValues(alpha: 0.1),
      fontFamily: 'Montserrat',
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(gray800Color),
        checkColor: WidgetStateProperty.all(yellow800Color),
        splashRadius: 0,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gray800Color,
        hintStyle: TextStyle(
          color: gray400Color,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12.8,
        ),
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: yellow800Color, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        hoverColor: gray800Color,
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: transparentColor,
        tileHeight: 48,
        iconTheme: WidgetStateProperty<IconThemeData>.fromMap(<
          WidgetStatesConstraint,
          IconThemeData
        >{
          WidgetState.selected: IconThemeData(color: yellow800Color, size: 18),
          WidgetState.any: IconThemeData(color: gray400Color, size: 18),
        }),
        labelTextStyle: WidgetStateProperty<TextStyle>.fromMap(
          <WidgetStatesConstraint, TextStyle>{
            WidgetState.selected: TextStyle(
              color: gray100Color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
            WidgetState.any: TextStyle(
              color: gray400Color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          },
        ),
        indicatorColor: gray800Color,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      // iconButtonTheme: IconButtonThemeData(
      //   style: ButtonStyle(
      //     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      //     ),
      //   ),
      // ),
      dividerTheme: DividerThemeData(
        color: gray400Color,
        thickness: 0.6,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: yellow800Color,
        strokeWidth: 1.5,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: gray800Color,
        width: 750,
        showCloseIcon: false,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: gray900Color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        titleTextStyle: TextStyle(
          color: gray100Color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: gray850Color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 18,
        labelTextStyle: WidgetStateProperty.all<TextStyle>(
          TextStyle(
            color: gray100Color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
          ),
        ),
        menuPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: TextStyle(
          color: gray100Color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat',
        ),
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(seconds: 2),
        preferBelow: true,
        verticalOffset: 10,
      ),
    );
  }
}

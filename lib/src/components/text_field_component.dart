import 'package:flutter/material.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';

class TextFieldComponent extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final IconData? icon;
  const TextFieldComponent({
    super.key,
    this.hintText,
    this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null
            ? Icon(
                icon,
                size: 18,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray400Color
                    : LightTheme.gray400Color,
              )
            : null,
      ),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.gray100Color
            : LightTheme.gray900Color,
      ),
    );
  }
}

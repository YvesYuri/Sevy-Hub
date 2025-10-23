import 'package:flutter/material.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';

class TextFieldComponent extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool? enabled;
  final FocusNode? focusNode;
  final VoidCallback? onTapTrailingIcon;
  final bool? obscureText;

  const TextFieldComponent({
    super.key,
    this.hintText,
    this.controller,
    this.leadingIcon,
    this.trailingIcon,
    this.enabled,
    this.focusNode,
    this.onTapTrailingIcon,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText ?? false,
      enabled: enabled ?? true,
      mouseCursor: enabled == true
          ? SystemMouseCursors.text
          : SystemMouseCursors.forbidden,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: leadingIcon != null
            ? Icon(
                leadingIcon,
                size: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray400Color
                    : LightTheme.gray400Color,
              )
            : null,
        suffixIcon: trailingIcon != null
            ? MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onTapTrailingIcon,
                  child: Icon(
                    trailingIcon,
                    size: 18,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray100Color
                        : LightTheme.gray900Color,
                  ),
                ),
              )
            : null,
      ),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: enabled == true
            ? (Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray100Color
                  : LightTheme.gray900Color)
            : (Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray400Color
                  : LightTheme.gray400Color),
      ),
    );
  }
}

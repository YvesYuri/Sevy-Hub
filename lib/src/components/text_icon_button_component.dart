import 'package:flutter/material.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart' show LightTheme;

class TextIconButtonComponent extends StatelessWidget {
  final String text;
  final double? width;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool enabled;
  final bool filled;
  const TextIconButtonComponent({
    super.key,
    required this.text,
    this.width,
    this.icon,
    required this.onPressed,
    this.enabled = true,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled
          ? (Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.yellow800Color
                : LightTheme.yellow500Color)
          : (Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.transparentColor
                : LightTheme.transparentColor),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(4),
        mouseCursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 11,
            bottom: 13,
            left: 16,
            right: 16,
          ),
          child: SizedBox(
            width: width,
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: filled
                      ? (Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.gray900Color  
                            : LightTheme.gray900Color)
                      : (enabled
                            ? (Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.yellow800Color
                                  : LightTheme.yellow500Color)
                            : (Theme.of(context).brightness == Brightness.dark
                                  ? DarkTheme.gray400Color
                                  : LightTheme.gray400Color)),
                ),
                const SizedBox(width: 11),
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: enabled
                        ? (Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.gray100Color
                              : LightTheme.gray900Color)
                        : (Theme.of(context).brightness == Brightness.dark
                              ? DarkTheme.gray400Color
                              : LightTheme.gray400Color),
                    fontSize: 14,
                    fontWeight: filled ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

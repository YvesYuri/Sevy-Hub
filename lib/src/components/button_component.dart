import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';

class ButtonComponent extends StatelessWidget {
  final String? text;
  final double? width;
  final bool? filled;
  final bool? bordered;
  final dynamic icon;
  final bool? boldText;
  final bool? isLoading;
  final bool? enabled;
  final VoidCallback onPressed;
  const ButtonComponent({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.filled,
    this.bordered,
    this.icon,
    this.boldText,
    this.isLoading,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: bordered == true
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray400Color
                    : LightTheme.gray400Color,
                width: 1,
              ),
            )
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.transparentColor
                    : LightTheme.transparentColor,
                width: 0,
              ),
            ),
      color: filled == true
          ? (Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.yellow800Color
                : LightTheme.yellow500Color)
          : (Theme.of(context).brightness == Brightness.dark
                ? DarkTheme.gray900Color
                : LightTheme.gray100Color),
      child: InkWell(
        onTap: enabled == true ? onPressed : null,
        borderRadius: BorderRadius.circular(4),
        hoverColor: filled == true
            ? (Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.yellow500Color
                  : LightTheme.yellow800Color)
            : (Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.transparentColor
                  : LightTheme.transparentColor),
        mouseCursor: enabled == true
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
          child: SizedBox(
            width: width,
            child: isLoading == true
                ? Container(
                  alignment: Alignment.center,
                  height: 20,
                  width: 20,
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: filled == true
                          ? (Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.gray900Color
                                : LightTheme.gray900Color)
                          : (Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.yellow800Color
                                : LightTheme.yellow500Color),
                    ),
                  ),
                )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        icon is String
                            ? SvgPicture.asset(icon, height: 18)
                            : Icon(
                                icon,
                                size: 18,
                                color: filled == true
                                    ? (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.gray900Color
                                          : LightTheme.gray900Color)
                                    : (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.yellow800Color
                                          : LightTheme.yellow500Color),
                              ),
                        const SizedBox(width: 11),
                      ],
                      text == null
                          ? Container()
                          : Text(
                              text!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: filled == true
                                    ? (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.gray900Color
                                          : LightTheme.gray900Color)
                                    : (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.gray100Color
                                          : LightTheme.gray900Color),
                                fontSize: 14,
                                fontWeight: boldText == true
                                    ? FontWeight.w600
                                    : FontWeight.w500,
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

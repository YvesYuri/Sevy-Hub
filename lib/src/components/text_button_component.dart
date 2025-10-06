import 'package:flutter/material.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';

class TextButtonComponent extends StatelessWidget {
  final String text;
  final double? width;
  final VoidCallback onPressed;
  const TextButtonComponent({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.yellow800Color
            : LightTheme.yellow500Color,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        hoverColor: Theme.of(context).brightness == Brightness.dark
            ? DarkTheme.yellow500Color
            : LightTheme.yellow800Color,
        mouseCursor: SystemMouseCursors.click,    
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: SizedBox(
            width: width,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.blackColor
                    : LightTheme.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

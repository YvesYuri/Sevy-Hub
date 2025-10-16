import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:particles_network/particles_network.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sevyhub/src/components/button_component.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:sevyhub/src/utils/image_util.dart';

class NotFoundView extends StatelessWidget {
  final String routeName;

  const NotFoundView({super.key,required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: ParticleNetwork(
                particleCount: 80,
                maxSpeed: 0.5,
                maxSize: 2.5,
                lineWidth: 0.5,
                lineDistance: 100,
                particleColor: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.yellow800Color
                    : LightTheme.yellow500Color,
                lineColor: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.yellow500Color
                    : LightTheme.yellow800Color,
                touchActivation: true,
                drawNetwork: true,
                fill: true,
                isComplex: true,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.sealWarning(),
                  size: 48,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.gray100Color
                      : LightTheme.gray900Color,
                ),
                const SizedBox(height: 14),
                Text(
                  'Page Not Found',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray100Color
                        : LightTheme.gray900Color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The route "$routeName" does not exist',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray400Color
                        : LightTheme.gray400Color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                ButtonComponent(
                  text: "Back to Home",
                  onPressed: () => context.go('/device'),
                  filled: true,
                  enabled: true,
                  width: 120,
                  boldText: true,
                ),
              ],
            ),
          ),
          Positioned(
            top: 14,
            left: 11,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: Offset(1, 1), // deslocamento da sombra
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    ImagesUtil.logoColorImage,
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  "Sevy Hub",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray100Color
                        : LightTheme.gray900Color,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 14,
            left: 11,
            child: Text(
              "© 2025 Sevy Hub. All rights reserved.",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray400Color
                    : LightTheme.gray400Color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:sevyhub/src/views/component_view.dart';

class SevyHub extends StatelessWidget {
  const SevyHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SevyHub',
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,
      themeMode: ThemeMode.light,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      home: ComponentView(),
    );
  }
}

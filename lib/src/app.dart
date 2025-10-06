import 'package:flutter/material.dart';
import 'package:sevyhub/src/routes/app_routes.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SevyHub',
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,
      themeMode: ThemeMode.light,
      theme: LightTheme.theme,
      darkTheme: DarkTheme.theme,
      routerConfig: AppRoutes.router,
    );
  }
}

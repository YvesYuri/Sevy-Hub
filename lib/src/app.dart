import 'package:flutter/material.dart';
import 'package:sevyhub/src/modules/design_library/design_library_controller.dart';
import 'package:sevyhub/src/modules/navigation/navigation_controller.dart';
import 'package:sevyhub/src/routes/app_routes.dart';
import 'package:sevyhub/src/services/storage_service.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (ctx) => StorageService()),
        ChangeNotifierProvider(create: (ctx) => NavigationController()),
        ChangeNotifierProvider(
          create: (ctx) => DesignLibraryController(
            storageService: ctx.read<StorageService>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'SevyHub',
        debugShowCheckedModeBanner: false,
        // debugShowMaterialGrid: true,
        themeMode: ThemeMode.dark,
        theme: LightTheme.theme,
        darkTheme: DarkTheme.theme,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}

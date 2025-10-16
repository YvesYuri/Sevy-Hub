import 'package:flutter/material.dart';
import 'package:sevyhub/src/view_models/navigation_view_model.dart';
import 'package:sevyhub/src/routes/app_routes.dart';
import 'package:sevyhub/src/services/authentication_service.dart';
import 'package:sevyhub/src/services/storage_service.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/view_models/authentication_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (ctx) => AuthenticationService(),
        ),
        Provider<StorageService>(create: (ctx) => StorageService()),
        ChangeNotifierProvider<AuthenticationViewModel>(
          create: (ctx) =>
              AuthenticationViewModel(ctx.read<AuthenticationService>()),
        ),
        ChangeNotifierProvider<NavigationViewModel>(
          create: (ctx) =>
              NavigationViewModel(ctx.read<AuthenticationService>()),
        ),
      ],
      child: Selector<AuthenticationViewModel, ValueNotifier<bool>>(
        selector: (context, viewModel) => viewModel.isLoggedIn,
        builder: (context, isLoggedInNotifier, child) {
          return MaterialApp.router(
            title: 'Sevy Hub',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: LightTheme.theme,
            darkTheme: DarkTheme.theme,
            routerConfig: AppRoutes.createRouter(isLoggedInNotifier),
          );
        },
      ),
    );
  }
}

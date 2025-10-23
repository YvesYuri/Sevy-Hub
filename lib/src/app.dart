import 'package:flutter/material.dart';
import 'package:sevyhub/src/services/database_service.dart';
import 'package:sevyhub/src/services/file_download_service.dart';
import 'package:sevyhub/src/services/file_picker_service.dart';
import 'package:sevyhub/src/services/graphic_service.dart';
import 'package:sevyhub/src/view_models/design_library_view_model.dart';
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
        Provider<AuthenticationService>(create: (ctx) => AuthenticationService()),
        Provider<StorageService>(create: (ctx) => StorageService()),
        Provider<FilePickerService>(create: (ctx) => FilePickerService()),
        Provider<FileDownloadService>(create: (ctx) => FileDownloadService()),
        Provider<GraphicService>(create: (ctx) => GraphicService()),
        Provider<DatabaseService>(create: (ctx) => DatabaseService()),
        ChangeNotifierProvider<AuthenticationViewModel>(
          create: (ctx) =>
              AuthenticationViewModel(ctx.read<AuthenticationService>()),
        ),
        ChangeNotifierProvider<NavigationViewModel>(
          create: (ctx) =>
              NavigationViewModel(ctx.read<AuthenticationService>()),
        ),
        ChangeNotifierProvider<DesignLibraryViewModel>(
          create: (ctx) => DesignLibraryViewModel(
            ctx.read<FilePickerService>(),
            ctx.read<FileDownloadService>(),
            ctx.read<AuthenticationService>(),
            ctx.read<StorageService>(),
            ctx.read<GraphicService>(),
            ctx.read<DatabaseService>(),
          ),
        ),
      ],
      child: Selector<AuthenticationViewModel, ValueNotifier<bool>>(
        selector: (context, viewModel) => viewModel.isLoggedIn,
        builder: (context, isLoggedInNotifier, child) {
          return MaterialApp.router(
            title: 'Sevy Hub',
            debugShowCheckedModeBanner: false,
            // debugShowMaterialGrid: true,
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

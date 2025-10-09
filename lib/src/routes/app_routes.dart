import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevyhub/src/modules/device/device_view.dart';
import 'package:sevyhub/src/modules/navigation/navigation_view.dart';
import 'package:sevyhub/src/modules/design_library/design_library_view.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/device',
    routes: [
      ShellRoute(
        builder: (context, state, view) {
          return NavigationView(view: view);
        },
        routes: [
          GoRoute(
            path: '/device',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const DeviceView(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween(
                            begin: const Offset(
                              0.05,
                              0,
                            ),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
              );
            },
          ),
          GoRoute(
            path: '/design_library',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const DesignLibraryView(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween(
                            begin: const Offset(
                              0.05,
                              0,
                            ),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
              );
            },
          ),
        ],
      ),
    ],
  );
}

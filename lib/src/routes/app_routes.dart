import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevyhub/src/modules/device/device_view.dart';
import 'package:sevyhub/src/modules/navigation/navigation_view.dart';
import 'package:sevyhub/src/modules/stl_gallery/stl_gallery_view.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
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
            path: '/stl_gallery',
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const StlGalleryView(),
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

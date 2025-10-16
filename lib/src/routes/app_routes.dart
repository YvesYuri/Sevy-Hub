import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sevyhub/src/views/authentication_view.dart';
import 'package:sevyhub/src/views/design_library_view.dart';
import 'package:sevyhub/src/views/device_view.dart';
import 'package:sevyhub/src/views/navigation_view.dart';
import 'package:sevyhub/src/views/not_found_view.dart';

class AppRoutes {
  static GoRouter createRouter(ValueNotifier<bool> isLoggedInNotifier) {
    return GoRouter(
      initialLocation: '/device',
      debugLogDiagnostics: true,
      errorPageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: NotFoundView(
            routeName: state.matchedLocation,
          ),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
      redirect: (context, state) {
        final bool isLoggedIn = isLoggedInNotifier.value;
        final bool isAuthRoute = state.matchedLocation == '/authentication';
        if (!isLoggedIn && !isAuthRoute) {
          return '/authentication';
        }
        if (isLoggedIn && isAuthRoute) {
          return '/device';
        }

        return null;
      },
      refreshListenable: isLoggedInNotifier,
      routes: [
        GoRoute(
          path: '/authentication',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const AuthenticationView(),
              transitionDuration: const Duration(milliseconds: 200),
              reverseTransitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),
        ShellRoute(
          pageBuilder: (context, state, view) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: NavigationView(view: view),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: child,
                    );
                  },
            );
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
                              begin: const Offset(0.05, 0),
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
              path: '/design-library',
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
                              begin: const Offset(0.05, 0),
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
}

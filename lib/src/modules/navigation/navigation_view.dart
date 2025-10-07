import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/modules/navigation/navigation_controller.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:sevyhub/src/utils/image_utils.dart';

class NavigationView extends StatelessWidget {
  final Widget view;
  const NavigationView({super.key, required this.view});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int selectedIndex = 0;
    if (location.startsWith('/stl_gallery')) {
      selectedIndex = 1;
    }
    return Scaffold(
      body: Consumer<NavigationController>(
        builder: (context, navigationController, child) {
          return Stack(
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: navigationController.isExpanded ? 199 : 54,
                  ),
                  Expanded(child: view),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: navigationController.isExpanded ? 200 : 55,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  elevation: 5,
                  shadowColor: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.gray100Color.withValues(alpha: 0.9)
                      : LightTheme.gray900Color.withValues(alpha: 0.3),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.gray900Color
                      : LightTheme.gray100Color,
                  child: NavigationDrawer(
                    tilePadding: EdgeInsets.zero,
                    selectedIndex: selectedIndex,
                    header: Container(
                      padding: const EdgeInsets.only(
                        left: 11,
                        top: 14,
                        bottom: 36,
                      ),
                      width: double.maxFinite,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                navigationController.toggleNavigation();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: Offset(
                                        1,
                                        1,
                                      ), // deslocamento da sombra
                                    ),
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  ImageUtils.logoColorImage,
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              final offsetAnimation = Tween<Offset>(
                                begin: const Offset(-0.1, 0),
                                end: Offset.zero,
                              ).animate(animation);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: navigationController.isExpanded
                                ? Text(
                                    "Sevy Hub",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.gray100Color
                                          : LightTheme.gray900Color,
                                    ),
                                    key: ValueKey('expanded_device'),
                                  )
                                : const SizedBox.shrink(
                                    key: ValueKey('collapsed_device'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    onDestinationSelected: (index) {
                      switch (index) {
                        case 0:
                          context.go('/device');
                          break;
                        case 1:
                          context.go('/stl_gallery');
                          break;
                      }
                    },
                    footer: Container(
                      padding: const EdgeInsets.only(left: 14, bottom: 14),
                      width: double.maxFinite,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                navigationController.toggleNavigation();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: Offset(
                                        1,
                                        1,
                                      ), // deslocamento da sombra
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 13,
                                  backgroundColor: Colors.blueAccent,
                                  child: Text(
                                    "YS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            transitionBuilder: (child, animation) {
                              final offsetAnimation = Tween<Offset>(
                                begin: const Offset(-0.1, 0),
                                end: Offset.zero,
                              ).animate(animation);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: navigationController.isExpanded
                                ? Text(
                                    "Yves Silva",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.gray100Color
                                          : LightTheme.gray900Color,
                                    ),
                                    key: ValueKey('expanded_device'),
                                  )
                                : const SizedBox.shrink(
                                    key: ValueKey('collapsed_device'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    children: [
                      // const Divider(thickness: 1, height: 1),
                      NavigationDrawerDestination(
                        icon: Transform.rotate(
                          angle: 180 * 3.14 / 180,
                          child: Icon(PhosphorIcons.deviceTabletSpeaker()),
                        ),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: navigationController.isExpanded
                              ? const Text(
                                  "Device",
                                  key: ValueKey('expanded_device'),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('collapsed_device'),
                                ),
                        ),
                      ),
                      NavigationDrawerDestination(
                        icon: Icon(PhosphorIcons.sphere()),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: navigationController.isExpanded
                              ? const Text(
                                  "Design Library",
                                  key: ValueKey('expanded_stl'),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('collapsed_stl'),
                                ),
                        ),
                      ),

                      NavigationDrawerDestination(
                        icon: Icon(PhosphorIcons.chartBar()),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: navigationController.isExpanded
                              ? const Text(
                                  "Statistics",
                                  key: ValueKey('expanded_stats'),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('collapsed_stats'),
                                ),
                        ),
                      ),

                      NavigationDrawerDestination(
                        icon: Icon(PhosphorIcons.clockCounterClockwise()),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: navigationController.isExpanded
                              ? const Text(
                                  "Print History",
                                  key: ValueKey('expanded_history'),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('collapsed_history'),
                                ),
                        ),
                      ),

                      NavigationDrawerDestination(
                        icon: Icon(PhosphorIcons.filmReel()),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: navigationController.isExpanded
                              ? const Text(
                                  "Spoolman",
                                  key: ValueKey('expanded_spool'),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('collapsed_spool'),
                                ),
                        ),
                      ),
                      NavigationDrawerDestination(
                        icon: Icon(PhosphorIcons.stack()),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: navigationController.isExpanded
                              ? const Text(
                                  "Slicer",
                                  key: ValueKey('expanded_slicer'),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('collapsed_slicer'),
                                ),
                        ),
                      ),

                      NavigationDrawerDestination(
                        icon: Icon(PhosphorIcons.toolbox()),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: navigationController.isExpanded
                              ? const Text(
                                  "Tools",
                                  key: ValueKey('expanded_tools'),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('collapsed_tools'),
                                ),
                        ),
                      ),
                      // const Divider(),
                      NavigationDrawerDestination(
                        icon: Icon(PhosphorIcons.plugs()),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: navigationController.isExpanded
                              ? const Text(
                                  "Integrations",
                                  key: ValueKey('expanded_integrations'),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('collapsed_integrations'),
                                ),
                        ),
                      ),

                      NavigationDrawerDestination(
                        icon: Icon(PhosphorIcons.gearSix()),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: const Offset(-0.1, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: navigationController.isExpanded
                              ? const Text(
                                  "Settings",
                                  key: ValueKey('expanded_settings'),
                                )
                              : const SizedBox.shrink(
                                  key: ValueKey('collapsed_settings'),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const VerticalDivider(thickness: 1, width: 1),
            ],
          );
        },
      ),
    );
  }
}

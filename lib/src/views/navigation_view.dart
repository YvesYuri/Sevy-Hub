import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:particles_network/particles_network.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/view_models/navigation_view_model.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:sevyhub/src/utils/image_util.dart';

class NavigationView extends StatefulWidget {
  final Widget view;
  const NavigationView({super.key, required this.view});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final location = GoRouterState.of(context).uri.toString();
      final navigationViewModel = context.read<NavigationViewModel>();
      if (location.startsWith('/device')) {
        navigationViewModel.setSelectedIndex(0);
      } else if (location.startsWith('/design-library')) {
        navigationViewModel.setSelectedIndex(1);
      } else {
        navigationViewModel.setSelectedIndex(-1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Consumer<NavigationViewModel>(
            builder: (context, navigationViewModel, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: navigationViewModel.isExpanded ? 200 : 55,
                child: Material(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  elevation: 5,
                  shadowColor: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.gray100Color.withValues(alpha: 0.9)
                      : LightTheme.gray900Color.withValues(alpha: 0.3),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? DarkTheme.gray900Color
                      : LightTheme.gray100Color,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.4,
                          child: ParticleNetwork(
                            particleCount: 18,
                            maxSpeed: 0.5,
                            maxSize: 2.5,
                            lineWidth: 0.5,
                            lineDistance: 58,
                            particleColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.yellow800Color
                                : LightTheme.yellow500Color,
                            lineColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.yellow500Color
                                : LightTheme.yellow800Color,
                            touchActivation: false,
                            drawNetwork: true,
                            fill: true,
                            isComplex: false,
                          ),
                        ),
                      ),
                      NavigationDrawer(
                        tilePadding: EdgeInsets.zero,
                        selectedIndex: navigationViewModel.selectedIndex,
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
                                child: Tooltip(
                                  message: navigationViewModel.isExpanded
                                      ? "Collapse Menu"
                                      : "Expand Menu",
                                  child: GestureDetector(
                                    onTap: () {
                                      navigationViewModel.expandMenuNavigation();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 10,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        ImagesUtil.logoColorImage,
                                        width: 30,
                                        height: 30,
                                      ),
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
                                child: navigationViewModel.isExpanded
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
                              navigationViewModel.setSelectedIndex(0);
                              break;
                            case 1:
                              context.go('/design-library');
                              navigationViewModel.setSelectedIndex(1);
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
                                    navigationViewModel.signOut();
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
                                      backgroundColor:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.yellow800Color
                                          : LightTheme.yellow800Color,
                                      child: Text(
                                        navigationViewModel.getUserInitials(),
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? DarkTheme.gray900Color
                                              : LightTheme.gray900Color,
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
                                child: navigationViewModel.isExpanded
                                    ? Text(
                                        navigationViewModel.getUserDisplayName(),
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
                              child: navigationViewModel.isExpanded
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
                              child: navigationViewModel.isExpanded
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
                              child: navigationViewModel.isExpanded
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
                              child: navigationViewModel.isExpanded
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
                              child: navigationViewModel.isExpanded
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
                              child: navigationViewModel.isExpanded
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
                              child: navigationViewModel.isExpanded
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
                              child: navigationViewModel.isExpanded
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
                              child: navigationViewModel.isExpanded
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
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(child: widget.view),
        ],
      ),
    );
  }
}

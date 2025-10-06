import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sevyhub/src/theme/light_theme.dart';

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
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: NavigationDrawer(
              tilePadding: EdgeInsets.zero,
              selectedIndex: selectedIndex,
              header: Container(
                padding: EdgeInsets.only(left: 17, top: 14, bottom: 14),
                width: double.maxFinite,
                alignment: Alignment.centerLeft,
                child: Icon(
                  PhosphorIcons.list(),
                  size: 20,
                  color: LightTheme.gray400Color,
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
              children: [
                Divider(thickness: 1, height: 1),
                NavigationDrawerDestination(
                  icon: Transform.rotate(
                    angle: 180 * 3.14 / 180,
                    child: Icon(PhosphorIcons.deviceTabletSpeaker()),
                  ),
                  label: Text("Device"),
                ),
                NavigationDrawerDestination(
                  icon: Icon(PhosphorIcons.sphere()),
                  label: Text("STL Gallery"),
                ),
                NavigationDrawerDestination(
                  icon: Icon(PhosphorIcons.chartBar()),
                  label: Text("Statistics"),
                ),
                NavigationDrawerDestination(
                  icon: Icon(PhosphorIcons.clockCounterClockwise()),
                  label: Text("Print History"),
                ),
                NavigationDrawerDestination(
                  icon: Icon(PhosphorIcons.filmReel()),
                  label: Text("Spoolman"),
                ),
                NavigationDrawerDestination(
                  icon: Icon(PhosphorIcons.stack()),
                  label: Text("Slicer"),
                ),
                NavigationDrawerDestination(
                  icon: Icon(PhosphorIcons.toolbox()),
                  label: Text("Tools"),
                ),
                Divider(thickness: 1, height: 1),
                NavigationDrawerDestination(
                  icon: Icon(PhosphorIcons.plugs()),
                  label: Text("Integrations"),
                ),
                NavigationDrawerDestination(
                  icon: Icon(PhosphorIcons.gearSix()),
                  label: Text("Settings"),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: view),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sevyhub/src/theme/light_theme.dart';

class ComponentView extends StatelessWidget {
  const ComponentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Meu App")),
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            minExtendedWidth: 240,
            minWidth: 46,
            leading: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 14, top: 4, bottom: 20),
              width: 240,
              child: Icon(
                PhosphorIcons.list(),
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : LightTheme.gray400Color,
                size: 19,
              ),
            ),
            leadingAtTop: true,
            destinations: [
              NavigationRailDestination(
                icon: Transform.rotate(
                  angle: 180 * 3.14 / 180,
                  child: Icon(PhosphorIcons.deviceTabletSpeaker()),
                ),
                label: Text("Device"),
              ),
              NavigationRailDestination(
                icon: Icon(PhosphorIcons.sphere()),
                label: Text("STL Gallery"),
              ),
              NavigationRailDestination(
                icon: Icon(PhosphorIcons.chartBar()),
                label: Text("Statistics"),
              ),
              NavigationRailDestination(
                icon: Icon(PhosphorIcons.clockCounterClockwise()),
                label: Text("Print History"),
              ),
              NavigationRailDestination(
                icon: Icon(PhosphorIcons.filmReel()),
                label: Text("Spoolman"),
              ),
              NavigationRailDestination(
                icon: Icon(PhosphorIcons.stack()),
                label: Text("Slicer"),
              ),
              NavigationRailDestination(
                icon: Icon(PhosphorIcons.gearSix()),
                label: Text("Settings"),
              ),
              NavigationRailDestination(
                icon: Icon(PhosphorIcons.plugs()),
                label: Text("Integrations"),
              ),
            ],
            selectedIndex: 0,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: Center(child: Text("Conteúdo da página"))),
        ],
      ),
    );
  }
}

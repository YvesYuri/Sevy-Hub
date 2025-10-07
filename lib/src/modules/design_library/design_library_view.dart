import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/modules/design_library/design_library_controller.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:three_js/three_js.dart' as three;

class DesignLibraryView extends StatefulWidget {
  const DesignLibraryView({super.key});

  @override
  State<DesignLibraryView> createState() => _DesignLibraryViewState();
}

class _DesignLibraryViewState extends State<DesignLibraryView> {
  @override
  void initState() {
    super.initState();
    three.ThreeJS(
      setup: () {
        print("aqui foi");
      },
      onSetupComplete: () {
        print("Three.js setup complete");
        // threeInitialized = true;
        // notifyListeners();
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final designLibraryController =
          Provider.of<DesignLibraryController>(context, listen: false);
      designLibraryController.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Design Library",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  "Hub > Design Library",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray400Color
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Consumer<DesignLibraryController>(
            builder: (context, designLibraryController, child) {
              return Expanded(
                child: designLibraryController.threeInitialized
                    ? Container()
                    : Container(),
                // child: GridView.builder(
                //   padding: const EdgeInsets.all(22),
                //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                //     maxCrossAxisExtent: 205,
                //     mainAxisExtent: 245,
                //     crossAxisSpacing: 8,
                //     mainAxisSpacing: 8,
                //   ),
                //   itemCount: 20,
                //   itemBuilder: (context, index) {
                //     return Container(
                //       decoration: BoxDecoration(
                //         // color: Theme.of(context).brightness == Brightness.dark
                //         //     ? DarkTheme.gray800Color
                //         //     : Colors.grey[200],
                //         borderRadius: BorderRadius.circular(4),
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           SizedBox(
                //             height: 153,
                //             child: Center(
                //               child: PhosphorIcon(
                //                 PhosphorIconsDuotone.image,
                //                 size: 32,
                //                 duotoneSecondaryColor:
                //                     Theme.of(context).brightness == Brightness.dark
                //                         ? DarkTheme.yellow800Color
                //                         : LightTheme.yellow500Color,
                //                 color: Theme.of(context).brightness ==
                //                         Brightness.dark
                //                     ? DarkTheme.gray400Color
                //                     : Colors.black26,
                //               ),
                //             ),
                //           ),
                //           Text(
                //             "Design Item ${index + 1}",
                //             style: TextStyle(
                //               fontSize: 14,
                //               fontWeight: FontWeight.w600,
                //               color: Theme.of(context).brightness == Brightness.dark
                //                   ? DarkTheme.gray100Color
                //                   : Colors.black87,
                //             ),
                //           ),
                //           const SizedBox(height: 6),
                //           Text(
                //             "160x153x64 mm",
                //             style: TextStyle(
                //               fontSize: 12,
                //               color: Theme.of(context).brightness == Brightness.dark
                //                   ? DarkTheme.gray400Color
                //                   : Colors.black54,
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/modules/design_library/design_library_controller.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';

class DesignLibraryView extends StatefulWidget {
  const DesignLibraryView({super.key});

  @override
  State<DesignLibraryView> createState() => _DesignLibraryViewState();
}

class _DesignLibraryViewState extends State<DesignLibraryView> {
  @override
  void initState() {
    super.initState();
    Provider.of<DesignLibraryController>(
      context,
      listen: false,
    ).getDesignFiles();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<DesignLibraryController>(
      context,
      listen: false,
    ).disposeScenes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DesignLibraryController>(
        builder: (context, designLibraryController, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 22, top: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Design Library",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
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
              Expanded(
                child: LiveGrid.options(
                  options: const LiveOptions(
                    delay: Duration(milliseconds: 250),
                    showItemInterval: Duration(milliseconds: 250),
                    showItemDuration: Duration(milliseconds: 500),
                    visibleFraction: 0.05,
                    reAnimateOnVisibility: true,
                  ),
                  padding: const EdgeInsets.all(22),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 205,
                    mainAxisExtent: 245,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: designLibraryController.designFiles.length,
                  itemBuilder: (context, index, animation) {
                    var designFile = designLibraryController.designFiles[index];

                    return FadeTransition(
                      opacity: Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(animation),
                      child: FutureBuilder(
                        future: designLibraryController.getDesignFileDetails(
                          designFile,
                        ),
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.hasData) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 153,
                                    child: Center(
                                      child: Image.memory(
                                        asyncSnapshot.data!.thumbnail,
                                      ),
                                      // child:PhosphorIcon(
                                      //   PhosphorIconsDuotone.image,
                                      //   size: 32,
                                      //   duotoneSecondaryColor:
                                      //       Theme.of(context).brightness ==
                                      //           Brightness.dark
                                      //       ? DarkTheme.yellow800Color
                                      //       : LightTheme.yellow500Color,
                                      //   color:
                                      //       Theme.of(context).brightness ==
                                      //           Brightness.dark
                                      //       ? DarkTheme.gray400Color
                                      //       : Colors.black26,
                                      // ),
                                    ),
                                  ),
                                  Text(
                                    asyncSnapshot.data!.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.gray100Color
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${asyncSnapshot.data!.objSize.height.toStringAsFixed(2)} x ${asyncSnapshot.data!.objSize.width.toStringAsFixed(2)} x ${asyncSnapshot.data!.objSize.length.toStringAsFixed(2)} mm",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.gray400Color
                                          : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "${asyncSnapshot.data!.fileSize.toStringAsFixed(2)} MB",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? DarkTheme.gray400Color
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator());
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

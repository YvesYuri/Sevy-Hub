import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/components/button_component.dart';
import 'package:sevyhub/src/models/design_library_model.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:sevyhub/src/view_models/design_library_view_model.dart';
import 'package:sevyhub/src/views/new_folder_view.dart';
import 'package:sevyhub/src/views/remove_item_dialog_view.dart';
import 'package:sevyhub/src/views/rename_item_form_view.dart';
import 'package:sevyhub/src/views/upload_files_view.dart';

class DesignLibraryView extends StatefulWidget {
  const DesignLibraryView({super.key});

  @override
  State<DesignLibraryView> createState() => _DesignLibraryViewState();
}

class _DesignLibraryViewState extends State<DesignLibraryView> {
  @override
  void initState() {
    super.initState();
    var viewModel = context.read<DesignLibraryViewModel>();
    viewModel.addListener(() {
      if (viewModel.state == DesignLibraryViewState.error) {
        String message = viewModel.errorMessage!;
        showSnackBar(true, message);
      }
      if (viewModel.state == DesignLibraryViewState.success) {
        String message = viewModel.successMessage!;
        showSnackBar(false, message);
      }
    });
  }

  void showUploadFiles() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const UploadFilesView();
      },
    );
  }

  void showFolderForm() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return NewFolderView();
      },
    );
  }

  void showRenameForm(DesignLibraryModel item) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return RenameItemFormView(item: item);
      },
    );
  }

  void showRemoveDialog(DesignLibraryModel item) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return RemoveItemDialogView(item: item);
      },
    );
  }

  void showSnackBar(bool isError, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 3500),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isError
                      ? PhosphorIcons.sealWarning()
                      : PhosphorIcons.sealCheck(),
                  size: 18,
                  color: isError
                      ? DarkTheme.errorColor
                      : DarkTheme.successColor,
                ),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: DarkTheme.gray100Color,
                  ),
                ),
              ],
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Icon(
                  PhosphorIcons.x(),
                  size: 16,
                  color: DarkTheme.gray100Color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 14, top: 9.8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Design Library",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? DarkTheme.gray100Color
                        : LightTheme.gray900Color,
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Consumer<DesignLibraryViewModel>(
                        builder: (context, designLibraryViewModel, child) {
                          return ButtonComponent(
                            text: "Upload File",
                            enabled: true,
                            onPressed: () async {
                              await designLibraryViewModel.pickFiles().then((
                                openUploadDialog,
                              ) {
                                if (openUploadDialog) {
                                  showUploadFiles();
                                }
                              });
                            },
                            fillColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.gray800Color
                                : LightTheme.gray300Color,
                            iconColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.yellow800Color
                                : LightTheme.yellow800Color,
                            textColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.gray100Color
                                : LightTheme.gray900Color,
                            boldText: true,
                            icon: PhosphorIcons.upload(),
                          );
                        },
                      ),
                      const SizedBox(width: 2),
                      const VerticalDivider(indent: 6, endIndent: 6),
                      const SizedBox(width: 2),
                      ButtonComponent(
                        text: "New Folder",
                        enabled: true,
                        onPressed: () {
                          showFolderForm();
                        },
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.gray800Color
                            : LightTheme.gray300Color,
                        iconColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.yellow800Color
                            : LightTheme.yellow800Color,
                        textColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? DarkTheme.gray100Color
                            : LightTheme.gray900Color,
                        boldText: true,
                        icon: PhosphorIcons.folderPlus(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "Hub > Root",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? DarkTheme.gray400Color
                    : Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Selector<DesignLibraryViewModel, Stream<List<DesignLibraryModel>>>(
                selector: (context, viewModel) => viewModel.getDesignLibraryPathStream(),
                builder: (context, stream, child) {
                  return StreamBuilder(
                    stream:stream,
                    builder: (context, designLibraryItems) {
                      return LiveGrid.options(
                        options: const LiveOptions(
                          delay: Duration.zero,
                          showItemInterval: Duration(milliseconds: 250),
                          showItemDuration: Duration(milliseconds: 350),
                          visibleFraction: 0.05,
                          reAnimateOnVisibility: true,
                        ),
                        // padding: const EdgeInsets.all(22),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 180,
                              mainAxisExtent: 220,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: designLibraryItems.data?.length ?? 0,
                        itemBuilder: (context, index, animation) {
                          var designItem = designLibraryItems.data![index];
                  
                          return FadeTransition(
                            opacity: Tween<double>(
                              begin: 0,
                              end: 1,
                            ).animate(animation),
                            child: designItem is DesignFileModel
                                ? Material(
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? DarkTheme.gray800Color
                                        : Colors.white,
                                    child: GestureDetector(
                                      onSecondaryTapDown: (TapDownDetails details) {
                                        final overlay =
                                            Overlay.of(
                                                  context,
                                                ).context.findRenderObject()
                                                as RenderBox;
                  
                                        final Offset offset = overlay.globalToLocal(
                                          details.globalPosition,
                                        );
                  
                                        showMenu(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                            offset.dx,
                                            offset.dy,
                                            overlay.size.width - offset.dx,
                                            overlay.size.height - offset.dy,
                                          ),
                                          popUpAnimationStyle: AnimationStyle(
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                              milliseconds: 150,
                                            ),
                                            reverseCurve: Curves.easeInOut,
                                            reverseDuration: const Duration(
                                              milliseconds: 150,
                                            ),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 162,
                                          ),
                                          items: <PopupMenuEntry>[
                                            PopupMenuItem(
                                              value: 'view',
                                              height: 32,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    PhosphorIcons.eye(),
                                                    size: 13,
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? DarkTheme.yellow800Color
                                                        : LightTheme.yellow500Color,
                                                  ),
                                                  const SizedBox(width: 11),
                                                  Text('View'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'slice',
                                              height: 32,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    PhosphorIcons.stack(),
                                                    size: 13,
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? DarkTheme.yellow800Color
                                                        : LightTheme.yellow500Color,
                                                  ),
                                                  const SizedBox(width: 11),
                                                  Text('Slice'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'download',
                                              height: 32,
                                              onTap: () async {
                                                await context
                                                    .read<DesignLibraryViewModel>()
                                                    .downloadDesignFile(designItem);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    PhosphorIcons.download(),
                                                    size: 13,
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? DarkTheme.yellow800Color
                                                        : LightTheme.yellow500Color,
                                                  ),
                                                  const SizedBox(width: 11),
                                                  Text('Download'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'rename',
                                              height: 32,
                                              onTap: () {
                                                showRenameForm(designItem);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    PhosphorIcons.cursorText(),
                                                    size: 13,
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? DarkTheme.yellow800Color
                                                        : LightTheme.yellow500Color,
                                                  ),
                                                  const SizedBox(width: 11),
                                                  Text('Rename'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'remove',
                                              height: 32,
                                              onTap: () {
                                                showRemoveDialog(designItem);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    PhosphorIcons.trash(),
                                                    size: 13,
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? DarkTheme.yellow800Color
                                                        : LightTheme.yellow500Color,
                                                  ),
                                                  const SizedBox(width: 11),
                                                  Text('Remove'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.circular(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 143,
                                              width: 143,
                                              child: Center(
                                                child: designItem.thumbnail != null
                                                    ? Image.memory(
                                                        base64Decode(
                                                          designItem.thumbnail!,
                                                        ),
                                                      )
                                                    : PhosphorIcon(
                                                        PhosphorIconsDuotone.image,
                                                        size: 32,
                                                        duotoneSecondaryColor:
                                                            Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? DarkTheme
                                                                  .yellow800Color
                                                            : LightTheme
                                                                  .yellow500Color,
                                                        color:
                                                            Theme.of(
                                                                  context,
                                                                ).brightness ==
                                                                Brightness.dark
                                                            ? DarkTheme.gray400Color
                                                            : Colors.black26,
                                                      ),
                                              ),
                                            ),
                                            Text(
                                              designItem.name,
                                              style: TextStyle(
                                                fontSize: 13,
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
                                              "${designItem.objectHeight!.toStringAsFixed(1)} x ${designItem.objectWidth!.toStringAsFixed(1)} x ${designItem.objectHeight!.toStringAsFixed(1)} mm",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color:
                                                    Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? DarkTheme.gray400Color
                                                    : Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "${context.read<DesignLibraryViewModel>().getFileSizeInMB(Uint8List.fromList([for (int i = 0; i < designItem.fileSize; i++) 0])).toStringAsFixed(2)} MB",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color:
                                                    Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? DarkTheme.gray400Color
                                                    : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Material(
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? DarkTheme.gray800Color
                                        : Colors.white,
                                    child: GestureDetector(
                                      onSecondaryTapDown: (TapDownDetails details) {
                                        final overlay =
                                            Overlay.of(
                                                  context,
                                                ).context.findRenderObject()
                                                as RenderBox;
                  
                                        final Offset offset = overlay.globalToLocal(
                                          details.globalPosition,
                                        );
                  
                                        showMenu(
                                          context: context,
                                          position: RelativeRect.fromLTRB(
                                            offset.dx,
                                            offset.dy,
                                            overlay.size.width - offset.dx,
                                            overlay.size.height - offset.dy,
                                          ),
                                          popUpAnimationStyle: AnimationStyle(
                                            curve: Curves.easeInOut,
                                            duration: const Duration(
                                              milliseconds: 150,
                                            ),
                                            reverseCurve: Curves.easeInOut,
                                            reverseDuration: const Duration(
                                              milliseconds: 150,
                                            ),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 162,
                                          ),
                                          items: <PopupMenuEntry>[
                                            PopupMenuItem(
                                              value: 'rename',
                                              height: 32,
                                              onTap: () {
                                                showRenameForm(designItem);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    PhosphorIcons.cursorText(),
                                                    size: 13,
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? DarkTheme.yellow800Color
                                                        : LightTheme.yellow500Color,
                                                  ),
                                                  const SizedBox(width: 11),
                                                  Text('Rename'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'remove',
                                              height: 32,
                                              onTap: () {
                                                showRemoveDialog(designItem);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    PhosphorIcons.trash(),
                                                    size: 13,
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? DarkTheme.yellow800Color
                                                        : LightTheme.yellow500Color,
                                                  ),
                                                  const SizedBox(width: 11),
                                                  Text('Remove'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: () {
                                          context
                                              .read<DesignLibraryViewModel>()
                                              .setPathFolderStack(designItem);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 153,
                                              child: Center(
                                                child: Icon(
                                                  PhosphorIconsThin.folder,
                                                  size: 76,
                                                  color:
                                                      Theme.of(
                                                            context,
                                                          ).brightness ==
                                                          Brightness.dark
                                                      ? DarkTheme.gray200Color
                                                      : Colors.black26,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              (designItem as DesignFolderModel)
                                                  .name,
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
                                              "0 files, 0folders",
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
                                      ),
                                    ),
                                  ),
                          );
                        },
                      );
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

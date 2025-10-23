import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/components/button_component.dart';
import 'package:sevyhub/src/components/text_field_component.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:sevyhub/src/view_models/design_library_view_model.dart';

class NewFolderView extends StatelessWidget {
  NewFolderView({super.key});

  final TextEditingController folderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(
        top: 16,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      title: Consumer<DesignLibraryViewModel>(
        builder: (context, designLibraryViewModel, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("New Folder"),
              designLibraryViewModel.state ==
                      DesignLibraryViewState.loadingNewFolder
                  ? Container(
                      height: 15,
                      width: 15,
                      margin: const EdgeInsets.only(right: 6),
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
            ],
          );
        },
      ),
      content: SizedBox(
        width: 400,
        child: Consumer<DesignLibraryViewModel>(
          builder: (context, designLibraryViewModel, child) {
            return TextFieldComponent(
              hintText: "Folder Name",
              enabled:
                  designLibraryViewModel.state !=
                  DesignLibraryViewState.loadingNewFolder,
              leadingIcon: PhosphorIcons.folderSimple(),
              controller: folderNameController,
            );
          },
        ),
      ),
      actions: [
        Consumer<DesignLibraryViewModel>(
          builder: (context, designLibraryViewModel, child) {
            return ButtonComponent(
              text: "Cancel",
              width: 78,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray800Color
                  : LightTheme.gray300Color,
              iconColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.yellow800Color
                  : LightTheme.yellow800Color,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray100Color
                  : LightTheme.gray900Color,
              icon: PhosphorIcons.x(),
              enabled:
                  designLibraryViewModel.state !=
                  DesignLibraryViewState.loadingUploadFiles,
              onPressed: () {
                Navigator.of(context).pop();
              },
              boldText: true,
            );
          },
        ),
        Consumer<DesignLibraryViewModel>(
          builder: (context, designLibraryViewModel, child) {
            return ButtonComponent(
              text: "Create",
              width: 78,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray800Color
                  : LightTheme.gray300Color,
              iconColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.yellow800Color
                  : LightTheme.yellow800Color,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray100Color
                  : LightTheme.gray900Color,
              icon: PhosphorIcons.plus(),
              enabled:
                  designLibraryViewModel.state !=
                  DesignLibraryViewState.loadingUploadFiles,
              onPressed: () async {
                await designLibraryViewModel
                    .createDesignFolder(folderNameController.text)
                    .then((_) {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    });
              },
              boldText: true,
            );
          },
        ),
      ],
    );
  }
}

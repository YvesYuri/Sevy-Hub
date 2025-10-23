import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/components/button_component.dart';
import 'package:sevyhub/src/components/text_field_component.dart';
import 'package:sevyhub/src/models/design_library_model.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:sevyhub/src/view_models/design_library_view_model.dart';

class RenameItemFormView extends StatelessWidget {
  final DesignLibraryModel item;
  RenameItemFormView({super.key, required this.item});

  final TextEditingController renameController = TextEditingController();

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
              const Text("Rename Item"),
              designLibraryViewModel.state ==
                      DesignLibraryViewState.loadingRenameItem
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
              hintText: "Name",
              enabled:
                  designLibraryViewModel.state !=
                  DesignLibraryViewState.loadingRenameItem,
              leadingIcon: PhosphorIcons.cursorText(),
              controller: renameController
                ..text = item.name.replaceAll('.stl', ''),
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
              icon: PhosphorIcons.x(),
              enabled:
                  designLibraryViewModel.state !=
                  DesignLibraryViewState.loadingRenameItem,
              onPressed: () {
                Navigator.of(context).pop();
              },
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray800Color
                  : LightTheme.gray300Color,
              iconColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.yellow800Color
                  : LightTheme.yellow800Color,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray100Color
                  : LightTheme.gray900Color,
              boldText: true,
            );
          },
        ),
        Consumer<DesignLibraryViewModel>(
          builder: (context, designLibraryViewModel, child) {
            return ButtonComponent(
              text: "Save",
              width: 70,
              icon: PhosphorIcons.floppyDisk(),
              enabled:
                  designLibraryViewModel.state !=
                  DesignLibraryViewState.loadingRenameItem,
              onPressed: () async {
                await designLibraryViewModel
                    .renameDesignItem(item, renameController.text)
                    .then((_) {
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    });
              },
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray800Color
                  : LightTheme.gray300Color,
              iconColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.yellow800Color
                  : LightTheme.yellow800Color,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray100Color
                  : LightTheme.gray900Color,
              boldText: true,
            );
          },
        ),
      ],
    );
  }
}

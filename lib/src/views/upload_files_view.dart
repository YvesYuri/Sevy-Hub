import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sevyhub/src/components/button_component.dart';
import 'package:sevyhub/src/theme/dark_theme.dart';
import 'package:sevyhub/src/theme/light_theme.dart';
import 'package:sevyhub/src/view_models/design_library_view_model.dart';

class UploadFilesView extends StatelessWidget {
  const UploadFilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Consumer<DesignLibraryViewModel>(
        builder: (context, designLibraryViewModel, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Uploading Files"),
              designLibraryViewModel.state ==
                      DesignLibraryViewState.loadingUploadFiles
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
      content: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 300),
        child: Builder(
          builder: (context) {
            var designLibraryViewModel = context.read<DesignLibraryViewModel>();
            return ListView.builder(
              itemCount: designLibraryViewModel.uploadFiles.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final uploadFile = designLibraryViewModel.uploadFiles[index];
                return StreamBuilder(
                  stream: designLibraryViewModel.uploadFileWithStatus(
                    uploadFile.file.id,
                  ),
                  builder: (context, status) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          uploadFile.file.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.gray100Color
                                : LightTheme.gray900Color,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${designLibraryViewModel.getFileSizeInMB(uploadFile.file.bytes).toStringAsFixed(2)} MB",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: DarkTheme.gray400Color,
                              ),
                            ),
                            Text(
                              status.hasData ? status.data! : "",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: DarkTheme.gray400Color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        LinearProgressIndicator(
                          value: designLibraryViewModel.getFileProgress(
                            status.data,
                          ),
                          backgroundColor: DarkTheme.gray800Color,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).brightness == Brightness.dark
                                ? DarkTheme.yellow800Color
                                : LightTheme.yellow500Color,
                          ),
                        ),
                        designLibraryViewModel.uploadFiles.length - 1 == index
                            ? Container()
                            : const SizedBox(height: 14),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        Consumer<DesignLibraryViewModel>(
          builder: (context, designLibraryViewModel, child) {
            return ButtonComponent(
              text: "Close",
              width: 68,
              icon: PhosphorIcons.x(),
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray800Color
                  : LightTheme.gray300Color,
              iconColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.yellow800Color
                  : LightTheme.yellow800Color,
              textColor: Theme.of(context).brightness == Brightness.dark
                  ? DarkTheme.gray100Color
                  : LightTheme.gray900Color,
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
      ],
    );
  }
}

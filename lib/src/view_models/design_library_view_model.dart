import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sevyhub/src/models/design_library_model.dart';
import 'package:sevyhub/src/models/file_model.dart';
import 'package:sevyhub/src/models/upload_file_model.dart';
import 'package:sevyhub/src/services/authentication_service.dart';
import 'package:sevyhub/src/services/database_service.dart';
import 'package:sevyhub/src/services/file_download_service.dart';
import 'package:sevyhub/src/services/file_picker_service.dart';
import 'package:sevyhub/src/services/graphic_service.dart';
import 'package:sevyhub/src/services/storage_service.dart';
import 'package:sevyhub/src/utils/exception_util.dart';
import 'package:uuid/uuid.dart';

enum DesignLibraryViewState {
  idle,
  loadingUploadFiles,
  loadingNewFolder,
  loadingRenameItem,
  loadingRemoveItem,
  loadingFileDownload,
  error,
  success,
}

class DesignLibraryViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;
  final FilePickerService _filePickerService;
  final FileDownloadService _fileDownloadService;
  final StorageService _storageService;
  final GraphicService _graphicService;
  final DatabaseService _databaseService;

  DesignLibraryViewModel(
    this._filePickerService,
    this._fileDownloadService,
    this._authenticationService,
    this._storageService,
    this._graphicService,
    this._databaseService,
  );

  DesignLibraryViewState _state = DesignLibraryViewState.idle;
  List<DesignLibraryModel> _designLibraryPathItems = [];
  String? _errorMessage;
  String? _successMessage;
  List<UploadFileModel> _uploadFiles = [];
  List<DesignFolderModel> _pathFolderStack = [];

  DesignLibraryViewState get state => _state;
  List<DesignLibraryModel> get designLibraryPathItems =>
      _designLibraryPathItems;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  List<UploadFileModel> get uploadFiles => _uploadFiles;
  List<DesignFolderModel> get pathStack => _pathFolderStack;

  Stream<List<DesignLibraryModel>> getDesignLibraryPathStream() {
    String path = _pathFolderStack.isEmpty
        ? "/children"
        : "/children/${_pathFolderStack.map((folder) => ("${folder.id}/children")).join()}";
    return _databaseService.getDesignLibraryPathStream(
      _authenticationService.currentUser!.email!,
      path,
    );
  }

  void setPathFolderStack(DesignFolderModel folder) {
    if (_pathFolderStack.any((f) => f.id == folder.id)) {
      int index = _pathFolderStack.indexWhere((f) => f.id == folder.id);
      _pathFolderStack = _pathFolderStack.sublist(0, index + 1);
    } else {
      _pathFolderStack.add(folder);
    }
    notifyListeners();
  }

  Future<bool> pickFiles() async {
    _uploadFiles.clear();
    _state = DesignLibraryViewState.loadingUploadFiles;
    notifyListeners();
    try {
      final files = await _filePickerService.pickFiles();
      final stream = getDesignLibraryPathStream();
      final items = await stream.first;
      final currentFiles = items.whereType<DesignFileModel>().toList();
      _uploadFiles = files.map((file) {
        var duplicateItems = duplicateItemNames(file.name, currentFiles);
        if (duplicateItems > 0) {
          file.name =
              "${file.name.replaceAll(".stl", "")}($duplicateItems).stl";
        }
        return UploadFileModel(file: file);
      }).toList();
      if (_uploadFiles.isEmpty) {
        _state = DesignLibraryViewState.idle;
        notifyListeners();
        return false;
      } else {
        return true;
      }
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = DesignLibraryViewState.error;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
      rethrow;
    }
  }

  int duplicateItemNames(String name, List<DesignLibraryModel> currentFiles) {
    var duplicateItems = currentFiles.where((item) => item.name == name).length;
    if (duplicateItems > 0) {
      var futureName = "${name.replaceAll(".stl", "")}($duplicateItems).stl";
      var futureNameDuplicate = currentFiles
          .where((item) => item.name == futureName)
          .length;
      if (futureNameDuplicate > 0) {
        return futureNameDuplicate + 1;
      } else {
        return duplicateItems;
      }
    } else {
      return 0;
    }
  }

  Stream<String> uploadFileWithStatus(String fileId) async* {
    try {
      final file = _uploadFiles.firstWhere((f) => f.file.id == fileId);
      await Future.delayed(const Duration(seconds: 2));
      await for (final status in _storageService.uploadFileWithStatus(
        _authenticationService.currentUser!.email!,
        file.file,
      )) {
        var resultStatus = status == "100%"
            ? "Generating metadata"
            : _uploadFiles[_uploadFiles.indexWhere(
                        (f) => f.file.id == file.file.id,
                      )]
                      .status =
                  status;

        if (status == "Completed") {
          await Future.delayed(const Duration(seconds: 3));
          var designFile = await getDesignFile(file.file);
          await _databaseService.addDesignLibraryItem(
            _authenticationService.currentUser!.email!,
            "/",
            designFile,
          );
        }

        if (_uploadFiles.every(
          (f) => f.status == "Completed" || f.status == "Error",
        )) {
          _state = DesignLibraryViewState.success;
          notifyListeners();
          _state = DesignLibraryViewState.idle;
        }

        yield resultStatus;
      }
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = DesignLibraryViewState.error;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
      rethrow;
    }
  }

  double? getFileProgress(String? status) {
    if (status != null && status.endsWith('%')) {
      return double.tryParse(status.replaceAll('%', ''))! / 100;
    } else if (status != null && status == "Error") {
      return 0.0;
    } else if (status != null && status == "Completed") {
      return 1.0;
    }
    return null;
  }

  double getFileSizeInMB(Uint8List bytes) {
    return bytes.lengthInBytes / (1024 * 1024);
  }

  Future<DesignFileModel> getDesignFile(FileModel file) async {
    try {
      return await _graphicService.getDesignFile(file);
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = DesignLibraryViewState.error;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
      rethrow;
    }
  }

  Future<void> createDesignFolder(String folderName) async {
    _state = DesignLibraryViewState.loadingNewFolder;
    notifyListeners();
    try {
      var designFolder = DesignFolderModel(
        id: Uuid().v4(),
        name: folderName,
        children: [],
        timeCreated: DateTime.now(),
        timeUpdated: DateTime.now(),
      );
      await Future.delayed(const Duration(seconds: 2));
      await _databaseService.addDesignLibraryItem(
        _authenticationService.currentUser!.email!,
        "/",
        designFolder,
      );
      _successMessage = 'Folder created successfully';
      _state = DesignLibraryViewState.success;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = DesignLibraryViewState.error;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
      rethrow;
    }
  }

  Future<void> renameDesignItem(DesignLibraryModel item, String newName) async {
    _state = DesignLibraryViewState.loadingRenameItem;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));

      final stream = getDesignLibraryPathStream();
      final items = await stream.first;
      final currentItems = item is DesignFileModel
          ? items.whereType<DesignFileModel>().toList()
          : items.whereType<DesignFolderModel>().toList();

      var duplicateItems = duplicateItemNames(newName, currentItems);

      if (duplicateItems > 0) {
        if (item is DesignFileModel) {
          newName = "${newName.replaceAll(".stl", "")}($duplicateItems).stl";
        } else {
          newName = "$newName($duplicateItems)";
        }
      }

      var renamedItem = item.copyWith(
        name: "$newName.stl",
        timeUpdated: DateTime.now(),
      );

      await _databaseService.updateDesignLibraryItem(
        _authenticationService.currentUser!.email!,
        "/",
        renamedItem,
      );
      _successMessage = 'Item renamed successfully';
      _state = DesignLibraryViewState.success;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = DesignLibraryViewState.error;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
      rethrow;
    }
  }

  Future<void> removeDesignItem(DesignLibraryModel item) async {
    _state = DesignLibraryViewState.loadingRemoveItem;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (item is DesignFileModel) {
        await _storageService.deleteFile(
          _authenticationService.currentUser!.email!,
          item.id,
        );
      }

      await _databaseService.removeDesignLibraryItem(
        _authenticationService.currentUser!.email!,
        "/",
        item.id,
      );
      _successMessage = 'Item removed successfully';
      _state = DesignLibraryViewState.success;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = DesignLibraryViewState.error;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
      rethrow;
    }
  }

  Future<void> downloadDesignFile(DesignFileModel item) async {
    _state = DesignLibraryViewState.loadingFileDownload;
    notifyListeners();
    try {
      String downloadUrl = await _storageService.getFileDownloadUrl(
        _authenticationService.currentUser!.email!,
        item.id,
      );

      await _fileDownloadService.downloadFile(downloadUrl, item.name);

      _successMessage = 'File download started';
      _state = DesignLibraryViewState.success;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = DesignLibraryViewState.error;
      notifyListeners();
      _state = DesignLibraryViewState.idle;
      rethrow;
    }
  }
}

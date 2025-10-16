import 'dart:math' as math;
import 'dart:typed_data';

import 'package:three_js/three_js.dart' as three;

abstract class DesignLibraryModel {}

class DesignFolderModel implements DesignLibraryModel {
  String name;
  String fullPath;
  int fileCount;
  int folderCount;

  DesignFolderModel({
    required this.name,
    required this.fullPath,
    required this.fileCount,
    required this.folderCount,
  });
}

class DesignFileModel implements DesignLibraryModel {
  String name;
  String fullPath;
  three.Vector3? objSize;
  Uint8List? thumbnail;
  FileMetadataModel? metadata;

  DesignFileModel({
    required this.name,
    required this.fullPath,
    this.objSize,
    this.thumbnail,
    this.metadata,
  });
}

class FileMetadataModel {
  double size;
  DateTime timeUpdated;
  DateTime timeCreated;

  FileMetadataModel({
    required this.size,
    required this.timeUpdated,
    required this.timeCreated,
  });

  factory FileMetadataModel.fromMap(Map<String, dynamic> map) {
    return FileMetadataModel(
      size: (map['size'] as int) / math.pow(1024, 2),
      timeUpdated: map['timeUpdated'],
      timeCreated: map['timeCreated'],
    );
  }
}

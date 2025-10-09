import 'dart:typed_data';

class DesignFileModel {
  final String name;
  final String url;
  final ObjSizeModel objSize;
  final Uint8List thumbnail;
  final double fileSize;

  DesignFileModel({
    required this.name,
    required this.url,
    required this.objSize,
    required this.thumbnail,
    required this.fileSize,
  });
}

class ObjSizeModel {
  final double height;
  final double width;
  final double length;

  ObjSizeModel({
    required this.height,
    required this.width,
    required this.length,
  });
}

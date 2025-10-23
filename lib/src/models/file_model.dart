import 'dart:typed_data';

class FileModel {
  String id;
  String name;
  Uint8List bytes;

  FileModel({
    required this.id,
    required this.name,
    required this.bytes,
  });
}
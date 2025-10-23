import 'package:sevyhub/src/models/file_model.dart';

class UploadFileModel {
  FileModel file;
  String? status;

  UploadFileModel({
    required this.file,
    this.status,
  });
}

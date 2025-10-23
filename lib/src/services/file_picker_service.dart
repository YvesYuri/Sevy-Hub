import 'package:file_picker/file_picker.dart';
import 'package:sevyhub/src/models/file_model.dart';
import 'package:sevyhub/src/utils/exception_util.dart';
import 'package:uuid/uuid.dart';

class FilePickerService {
  Future<List<FileModel>> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        withData: true,
        allowedExtensions: ['stl'],
      );

      List<FileModel> files = [];

      if (result != null) {
        for (var file in result.files) {
          if (file.bytes != null) {
            files.add(
              FileModel(id: Uuid().v4(), name: file.name, bytes: file.bytes!),
            );
          }
        }
      }

      return files;
    } catch (e) {
      throw AppException('Error picking files: $e');
    }
  }
}

import 'package:firebase_storage/firebase_storage.dart';
import 'package:sevyhub/src/models/file_model.dart';
import 'package:sevyhub/src/utils/exception_util.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<String> uploadFileWithStatus(String email, FileModel file) async* {
    try {
      final ref = _storage.ref().child('$email/${file.id}');
      final uploadTask = ref.putData(file.bytes);

      await for (final snapshot in uploadTask.snapshotEvents) {
        final status = snapshot.totalBytes > 0
            ? snapshot.bytesTransferred / snapshot.totalBytes
            : 0.0;

        if (snapshot.state == TaskState.success) {
          yield "Completed";
        } else if (snapshot.state == TaskState.error) {
          yield "Error";
        } else {
          yield "${(status * 100).toStringAsFixed(0)}%";
        }
      }
    } on FirebaseException catch (e) {
      throw AppException('Error uploading file ${file.name}: ${e.message}');
    } catch (e) {
      throw AppException('Unexpected error uploading file ${file.name}');
    }
  }

  Future<void> deleteFile(String email, String fileId) async {
    try {
      final ref = _storage.ref().child('$email/$fileId');
      await ref.delete();
    } on FirebaseException catch (e) {
      throw AppException('Error deleting file $fileId: ${e.message}');
    } catch (e) {
      throw AppException('Unexpected error deleting file $fileId');
    }
  }

  Future<String> getFileDownloadUrl(String email, String fileId) async {
    try {
      final ref = _storage.ref().child('$email/$fileId');
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw AppException('Error getting download URL for file $fileId: ${e.message}');
    } catch (e) {
      throw AppException('Unexpected error getting download URL for file $fileId');
    }
  }
}

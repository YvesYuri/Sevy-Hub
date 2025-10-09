import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<ListResult> listFilesAndFolders(String userPath) async {
    final ref = _storage.ref().child(userPath);
    final result = await ref.listAll();
    return result;
  }

  Future<Map<int?, Uint8List?>> getFileMetadataSizeAndBytes(String path) async {
    final ref = _storage.ref().child(path);
    final bytes = await ref.getData();
    final metadata = await ref.getMetadata();
    return {metadata.size: bytes};
}
}

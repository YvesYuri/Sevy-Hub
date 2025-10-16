import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<ListResult> listFilesAndFolders(String userPath) async {
    final ref = _storage.ref().child(userPath);
    final result = await ref.listAll();
    return result;
  }

  Future<Map<String, dynamic>> getFileMetadata(String path) async {
    final ref = _storage.ref().child(path);
    final metadata = await ref.getMetadata();
    return {
      "size": metadata.size,
      "timeUpdated": metadata.updated,
      "timeCreated": metadata.timeCreated,
    };
  }

  Future<Uint8List?> getFileBytes(String path) async {
    final ref = _storage.ref().child("/$path");
    final data = await ref.getData(40 * 1024 * 1024);
    return data;
  }

  Future<void> createFolder(String path) async {
    final ref = _storage.ref().child("$path/.keep");
    await ref.putData(Uint8List(0));
  }

  Future<void> deleteFile(String path) async {
    final ref = _storage.ref().child(path);
    await ref.delete();
  }
}

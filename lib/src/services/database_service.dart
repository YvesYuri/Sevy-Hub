import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sevyhub/src/models/design_library_model.dart';
import 'package:sevyhub/src/utils/exception_util.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<DesignLibraryModel>> getDesignLibraryPathStream(
    String email,
    String path,
  ) {
    try {
      return _firestore
          .collection('/design_library/$email$path')
          .snapshots()
          .map((snapshot) {
            if (snapshot.docs.isEmpty) {
              return [];
            }
            return snapshot.docs.map((doc) {              
              final data = doc.data();
              data['timeCreated'] = _timestampToDateTime(data['timeCreated']);
              data['timeUpdated'] = _timestampToDateTime(data['timeUpdated']);
              return DesignLibraryModel.fromJson(data);
            }).toList();
          });
    } catch (e) {
      throw AppException('Error fetching design library: $e');
    }
  }

  Future<void> addDesignLibraryItem(
    String email,
    String path,
    DesignLibraryModel item,
  ) async {
    try {
      final docRef = _firestore
          .collection('design_library/$email/$path')
          .doc(item.id);

      await docRef.set(item.toJson());
    } on FirebaseException catch (e) {
      throw AppException('Error adding item: ${e.message}');
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  Future<void> updateDesignLibraryItem(
    String email,
    String path,
    DesignLibraryModel updatedItem,
  ) async {
    try {
      final docRef = _firestore
          .collection('design_library/$email/$path')
          .doc(updatedItem.id);

      await docRef.update(updatedItem.toJson());
    } on FirebaseException catch (e) {
      throw AppException('Error updating item: ${e.message}');
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  Future<void> removeDesignLibraryItem(
    String email,
    String path,
    String itemId,
  ) async {
    try {
      final docRef = _firestore
           .collection('design_library/$email/$path')
          .doc(itemId);

      await docRef.delete();
    } on FirebaseException catch (e) {
      throw AppException('Error removing item: ${e.message}');
    } catch (e) {
      throw AppException('Unexpected error: $e');
    }
  }

  DateTime _timestampToDateTime(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds * 1000 + (timestamp.nanoseconds ~/ 1000000),
    );
  }
}

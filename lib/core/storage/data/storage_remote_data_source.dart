
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../base/exceptions.dart';
import 'storage_data_source.dart';
import 'package:path/path.dart' as p;

class StorageRemoteDataSource implements StorageDataSource {
  final FirebaseStorage storage;

  StorageRemoteDataSource({required this.storage});

  @override
  Future<List<String>> uploadFile(
      {required List<dynamic> files, required String userId}) async {
    try {
      return uploadFiles(files, userId);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  Future<List<String>> uploadFiles(List<dynamic> files, String userId) async {
    var imageUrls =
        await Future.wait(files.map((file) => uploadSingleFile(file, userId)));
    return imageUrls;
  }

  Future<String> uploadSingleFile(dynamic file, String userId) async {
    if (kIsWeb || file is Uint8List) {
      final snapshot = file is Uint8List
          ? await storage
              .ref(
                  '/users/$userId/temps/${DateTime.now().millisecondsSinceEpoch}_${UniqueKey()}')
              .putData(
                file,
              )
          : await storage
              .ref(
                  '/users/$userId/temps/${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}')
              .putData(
                await PickedFile(file.path).readAsBytes(),
              );

      return snapshot.ref.fullPath;
    }
    final snapshot = await storage
        .ref(
            '/users/$userId/temps/${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}')
        .putFile(
          file,
        );
    return snapshot.ref.fullPath;
  }
}

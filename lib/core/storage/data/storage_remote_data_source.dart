import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../base/exceptions.dart';
import 'storage_data_source.dart';
import 'package:path/path.dart' as p;

class StorageRemoteDataSource implements StorageDataSource {
  final FirebaseStorage storage;

  StorageRemoteDataSource({required this.storage});

  @override
  Future<List<String>> uploadFile(
      {required List<File> files, required String userId}) async {
    try {
      return uploadFiles(files, userId);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  Future<List<String>> uploadFiles(List<File> files, String userId) async {
    var imageUrls =
        await Future.wait(files.map((file) => uploadSingleFile(file, userId)));
    return imageUrls;
  }

  Future<String> uploadSingleFile(File file, String userId) async {
    final snapshot = await storage
        .ref(
            '/users/$userId/temps/${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}')
        .putFile(
          file,
        );
    return snapshot.ref.fullPath;
  }
}

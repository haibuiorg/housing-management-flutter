import 'dart:io';

abstract class StorageDataSource {
  Future<List<String>> uploadFile(
      {required List<File> files, required String userId});
}

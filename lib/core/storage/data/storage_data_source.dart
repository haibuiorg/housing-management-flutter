abstract class StorageDataSource {
  Future<List<String>> uploadFile(
      {required List<dynamic> files, required String userId});
}

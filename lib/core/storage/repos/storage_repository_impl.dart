import 'dart:io';

import 'package:priorli/core/base/result.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../data/storage_data_source.dart';
import 'storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  final StorageDataSource storageDataSource;

  StorageRepositoryImpl({required this.storageDataSource});
  @override
  Future<Result<List<String>>> uploadFile(
      {required List<dynamic> files, required String userId}) async {
    try {
      final fileUpload = await storageDataSource.uploadFile(
        files: files,
        userId: userId,
      );
      return ResultSuccess(fileUpload);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

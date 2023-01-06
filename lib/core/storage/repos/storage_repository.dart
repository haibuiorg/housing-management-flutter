import 'dart:io';

import 'package:priorli/core/base/result.dart';

abstract class StorageRepository {
  Future<Result<List<String>>> uploadFile({
    required List<dynamic> files,
    required String userId,
  });
}

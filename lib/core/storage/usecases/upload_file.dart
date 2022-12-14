import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/storage/repos/storage_repository.dart';

class UploadFile extends UseCase<List<String>, UploadFileParams> {
  final StorageRepository storageRepository;

  UploadFile({required this.storageRepository});

  @override
  Future<Result<List<String>>> call(UploadFileParams params) {
    return storageRepository.uploadFile(
        files: params.files, userId: params.userId);
  }
}

class UploadFileParams extends Equatable {
  final List<File> files;
  final String userId;

  const UploadFileParams({
    required this.files,
    required this.userId,
  });

  @override
  List<Object?> get props => [files, userId];
}

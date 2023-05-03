import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/storage/usecases/upload_file.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';
import 'package:priorli/presentation/file_selector/file_selector_state.dart';

class FileSelectorCubit extends Cubit<FileSelectorState> {
  final UploadFile _uploadFile;
  final GetUserInfo _getUserInfo;
  FileSelectorCubit(this._uploadFile, this._getUserInfo)
      : super(const FileSelectorState());

  Future<void> init(bool autoUpload) async {
    final getUserInfoResult = await _getUserInfo(NoParams());
    if (getUserInfoResult is ResultSuccess<User>) {
      emit(
          state.copyWith(user: getUserInfoResult.data, autoUpload: autoUpload));
    }
  }

  Future<void> loadFiles(List<dynamic> files) async {
    final List<dynamic> newFileList = List.from(state.selectedFiles ?? []);
    if (state.autoUpload == true) {
      await uploadNewFiles(files);
      return;
    }
    newFileList.addAll(files);
    emit(state.copyWith(selectedFiles: newFileList, uploading: false));
  }

  Future<void> removeFilesByPosition(int position) async {
    final List<File> newFileList = List.from(state.selectedFiles ?? []);
    newFileList.removeAt(position);
    if (state.autoUpload == true) {
      final List<String> currentLocations =
          List.from(state.uploadedLocations ?? []);
      currentLocations.removeAt(position);
      emit(state.copyWith(
          selectedFiles: newFileList, uploadedLocations: currentLocations));
      return;
    }
    emit(state.copyWith(selectedFiles: newFileList));
  }

  Future<void> uploadNewFiles(List<dynamic> files) async {
    emit(state.copyWith(uploading: true));
    final uploadResult = await _uploadFile(
        UploadFileParams(files: files, userId: state.user?.userId ?? ''));
    if (uploadResult is ResultSuccess<List<String>>) {
      final List<String> currentLocations =
          List.from(state.uploadedLocations ?? []);
      currentLocations.addAll(uploadResult.data);
      emit(
        state.copyWith(
            uploadedLocations: currentLocations,
            selectedFiles: [],
            uploading: false),
      );
      return;
    }
    emit(state.copyWith(uploading: false));
  }

  Future<void> uploadAllFiles() async {
    emit(state.copyWith(uploading: true));
    final uploadResult = await _uploadFile(UploadFileParams(
        files: state.selectedFiles ?? [], userId: state.user?.userId ?? ''));
    if (uploadResult is ResultSuccess<List<String>>) {
      emit(state.copyWith(
          uploadedLocations: uploadResult.data,
          selectedFiles: [],
          uploading: false));
      return;
    }
    emit(state.copyWith(uploading: false));
  }

  void clearSelectedFiles() {
    emit(state.copyWith(selectedFiles: [], uploadedLocations: []));
  }
}

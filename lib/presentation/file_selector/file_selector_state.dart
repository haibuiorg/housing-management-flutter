
import 'package:equatable/equatable.dart';
import 'package:priorli/core/user/entities/user.dart';

class FileSelectorState extends Equatable {
  final List<String>? uploadedLocations;
  final bool? autoUpload;
  final List<dynamic>? selectedFiles;
  final User? user;
  final bool? uploading;

  const FileSelectorState({
    this.uploadedLocations,
    this.user,
    this.selectedFiles,
    this.autoUpload,
    this.uploading,
  });

  FileSelectorState copyWith(
          {List<String>? uploadedLocations,
          User? user,
          bool? autoUpload,
          bool? uploading,
          List<dynamic>? selectedFiles}) =>
      FileSelectorState(
          selectedFiles: selectedFiles ?? this.selectedFiles,
          user: user ?? this.user,
          uploading: uploading ?? this.uploading,
          uploadedLocations: uploadedLocations ?? this.uploadedLocations,
          autoUpload: autoUpload ?? this.autoUpload);

  @override
  List<Object?> get props =>
      [uploadedLocations, user, selectedFiles, autoUpload, uploading];
}

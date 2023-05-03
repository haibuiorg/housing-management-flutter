import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/entities/translation.dart';
import 'package:priorli/core/storage/models/storage_item_model.dart';

class StorageItem extends Equatable {
  final String? id;
  final String storageLink;
  final String? presignedUrl;
  final int? expiredOn;
  final int? createdOn;
  final bool? isDeleted;
  final String? uploadedBy;
  final String? type;
  final String? name;
  final List<Translation>? summaryTranslation;

  const StorageItem(
      {this.id,
      required this.storageLink,
      this.summaryTranslation,
      this.presignedUrl,
      this.expiredOn,
      this.createdOn,
      this.isDeleted,
      this.type,
      this.name,
      this.uploadedBy});

  factory StorageItem.modelToEntity(StorageItemModel model) => StorageItem(
      storageLink: model.storage_link,
      id: model.id,
      presignedUrl: model.presigned_url,
      expiredOn: model.expired_on,
      createdOn: model.created_on,
      isDeleted: model.is_deleted,
      summaryTranslation: model.summary_translation
          ?.map((e) => Translation.modelToEntity(e))
          .toList(),
      type: model.type,
      name: model.name,
      uploadedBy: model.uploaded_by);

  StorageItem copyWith({
    String? id,
    String? storageLink,
    String? presignedUrl,
    int? expiredOn,
    int? createdOn,
    bool? isDeleted,
    String? uploadedBy,
    String? type,
    String? name,
    List<Translation>? summaryTranslation,
  }) =>
      StorageItem(
          storageLink: storageLink ?? this.storageLink,
          id: id ?? this.id,
          presignedUrl: presignedUrl ?? this.presignedUrl,
          expiredOn: expiredOn ?? this.expiredOn,
          createdOn: createdOn ?? this.createdOn,
          isDeleted: isDeleted ?? this.isDeleted,
          type: type ?? this.type,
          name: name ?? this.name,
          summaryTranslation: summaryTranslation ?? this.summaryTranslation,
          uploadedBy: uploadedBy ?? this.uploadedBy);

  @override
  List<Object?> get props => [
        id,
        storageLink,
        presignedUrl,
        expiredOn,
        createdOn,
        isDeleted,
        uploadedBy,
        type,
        summaryTranslation,
        name
      ];
}

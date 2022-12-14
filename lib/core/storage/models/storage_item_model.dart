// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'storage_item_model.g.dart';

/* 
    id?: string,
    storage_link: string,
    presigned_url?: string,
    expired_on?: number,
    is_deleted?: boolean,
    created_on?: number,
    uploaded_by?: string, 
    */

@JsonSerializable()
class StorageItemModel extends Equatable {
  final String? id;
  final String storage_link;
  final String? presigned_url;
  final int? expired_on;
  final int? created_on;
  final bool? is_deleted;
  final String? uploaded_by;
  final String? type;
  final String? name;

  const StorageItemModel(
      {this.id,
      required this.storage_link,
      this.presigned_url,
      this.expired_on,
      this.created_on,
      this.is_deleted,
      this.type,
      this.name,
      this.uploaded_by});

  factory StorageItemModel.fromJson(Map<String, dynamic> json) =>
      _$StorageItemModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        storage_link,
        presigned_url,
        expired_on,
        created_on,
        is_deleted,
        uploaded_by,
        type,
        name
      ];
}

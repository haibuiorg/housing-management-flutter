// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/messaging/models/translated_message_model.dart';
import 'package:priorli/core/storage/models/storage_item_model.dart';

part 'announcement_model.g.dart';

@JsonSerializable()
class AnnouncementModel extends Equatable {
  final String? id;
  final String? title;
  final String? subtitle;
  final String? body;
  final int? created_on;
  final String? created_by;
  final String? updated_by;
  final int? updated_on;
  final String? display_name;
  final bool? is_deleted;
  final List<StorageItemModel>? storage_items;
  final List<TranslatedMessageModel>? translated_body;
  final List<TranslatedMessageModel>? translated_title;
  final List<TranslatedMessageModel>? translated_subtitle;

  const AnnouncementModel(
      this.id,
      this.title,
      this.subtitle,
      this.body,
      this.created_on,
      this.created_by,
      this.updated_by,
      this.updated_on,
      this.storage_items,
      this.display_name,
      this.translated_body,
      this.translated_title,
      this.translated_subtitle,
      this.is_deleted);

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        body,
        created_by,
        created_on,
        updated_by,
        storage_items,
        updated_on,
        display_name,
        is_deleted,
        translated_body,
        translated_title,
        translated_subtitle
      ];
}

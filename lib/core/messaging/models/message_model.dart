// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/storage/models/storage_item_model.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel extends Equatable {
  final int? created_on;
  final String? id;
  final String? message;
  final String? sender_id;
  final String? sender_name;
  final int? updated_on;
  final List<String>? seen_by;
  final List<StorageItemModel>? storage_items;

  const MessageModel(
      {this.created_on,
      this.id,
      this.message,
      this.sender_id,
      this.sender_name,
      this.updated_on,
      this.storage_items,
      this.seen_by});
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  @override
  List<Object?> get props => [
        created_on,
        id,
        message,
        sender_id,
        sender_name,
        updated_on,
        seen_by,
        storage_items
      ];
}

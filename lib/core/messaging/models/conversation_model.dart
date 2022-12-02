// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation_model.g.dart';

@JsonSerializable()
class ConversationModel extends Equatable {
  final String? id;
  final String? channel_id;
  final List<String>? user_ids;
  final String? name;
  final String? status;
  final String? type;
  final bool? is_archived;
  final List<String>? last_message_not_seen_by;

  const ConversationModel(
      {this.id,
      this.channel_id,
      this.user_ids,
      this.name,
      this.status,
      this.is_archived,
      this.last_message_not_seen_by,
      this.type});

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        channel_id,
        user_ids,
        name,
        status,
        type,
        last_message_not_seen_by,
        is_archived
      ];
}

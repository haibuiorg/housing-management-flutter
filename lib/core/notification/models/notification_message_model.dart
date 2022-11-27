// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_message_model.g.dart';

@JsonSerializable()
class NotificationMessageModel extends Equatable {
  final String? id;
  final String? channel_key;
  final String? title;
  final String? body;
  final bool? auto_dismissible;
  final String? color;
  final bool? wake_up_screen;
  final String? app_route_location;
  final String? created_by;
  final String? display_name;
  final int? created_on;
  final bool? seen;

  const NotificationMessageModel(
      this.id,
      this.channel_key,
      this.title,
      this.body,
      this.auto_dismissible,
      this.color,
      this.wake_up_screen,
      this.app_route_location,
      this.created_by,
      this.display_name,
      this.created_on,
      this.seen);

  factory NotificationMessageModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationMessageModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        channel_key,
        title,
        body,
        auto_dismissible,
        color,
        wake_up_screen,
        app_route_location,
        created_by,
        display_name,
        created_on,
        seen
      ];
}

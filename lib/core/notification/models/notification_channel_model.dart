// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_channel_model.g.dart';

@JsonSerializable()
class NotificationChannelModel extends Equatable {
  final String? channel_key;
  final String? channel_name;
  final String? channel_description;
  final String? housing_company_id;
  final bool? is_active;

  const NotificationChannelModel(this.channel_key, this.channel_name,
      this.channel_description, this.housing_company_id, this.is_active);

  factory NotificationChannelModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationChannelModelFromJson(json);

  @override
  List<Object?> get props => [
        channel_key,
        channel_name,
        channel_description,
        housing_company_id,
        is_active
      ];
}

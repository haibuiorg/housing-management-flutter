// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

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

  const AnnouncementModel(
      this.id,
      this.title,
      this.subtitle,
      this.body,
      this.created_on,
      this.created_by,
      this.updated_by,
      this.updated_on,
      this.display_name,
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
        updated_on,
        display_name,
        is_deleted
      ];
}

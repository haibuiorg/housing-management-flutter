// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/event/entities/event_type.dart';

import '../entities/repeat.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final EventType
      type; //'generic'|'company_internal'|'company'|'apartment'|'personal',
  final String? company_id;
  final String? apartment_id;
  final int start_time;
  final int end_time;
  final Repeat? repeat; // 'daily'|'weekday'|'weekly'|'monthly'|'yearly';
  final int? repeat_until;
  final List<int>? reminders;
  final List<String> invitees;
  final List<String>? accepted;
  final List<String>? declined;
  final List<String>? join_links;
  final int created_on;
  final String created_by;
  final String created_by_name;
  final String? updated_by;
  final String? updated_by_name;
  final int? updated_on;
  final bool? is_deleted;

  const EventModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      this.reminders,
      this.repeat_until,
      this.company_id,
      this.apartment_id,
      required this.start_time,
      required this.end_time,
      this.repeat,
      required this.invitees,
      this.accepted,
      this.declined,
      this.join_links,
      required this.created_on,
      required this.created_by,
      required this.created_by_name,
      this.updated_by,
      this.updated_by_name,
      this.updated_on,
      this.is_deleted});

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        company_id,
        apartment_id,
        start_time,
        end_time,
        repeat,
        invitees,
        accepted,
        declined,
        join_links,
        created_by,
        created_on,
        created_by_name,
        updated_by,
        updated_by_name,
        updated_on,
        reminders,
        repeat_until,
        is_deleted
      ];
}

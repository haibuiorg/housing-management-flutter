import 'package:equatable/equatable.dart';
import 'package:priorli/core/event/models/event_model.dart';

import 'event_type.dart';
import 'repeat.dart';

class Event extends Equatable {
  final String id;
  final String name;
  final String description;
  final EventType type;
  final String? companyId;
  final String? apartmentId;
  final int startTime;
  final int endTime;
  final Repeat? repeat;
  final List<String> invitees;
  final List<String>? accepted;
  final List<String>? declined;
  final List<String>? joinLinks;
  final int createdOn;
  final String createdBy;
  final String createdByName;
  final String? updatedBy;
  final String? updatedByName;
  final int? updatedOn;
  final bool? isDeleted;
  final int? repeatUntil;
  final List<int>? reminders;

  const Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      this.reminders,
      this.repeatUntil,
      this.companyId,
      this.apartmentId,
      required this.startTime,
      required this.endTime,
      this.repeat,
      required this.invitees,
      this.accepted,
      this.declined,
      this.joinLinks,
      required this.createdOn,
      required this.createdBy,
      required this.createdByName,
      this.updatedBy,
      this.updatedByName,
      this.updatedOn,
      this.isDeleted});

  factory Event.modelToEntity(EventModel model) => Event(
      id: model.id,
      companyId: model.company_id,
      apartmentId: model.apartment_id,
      accepted: model.accepted,
      declined: model.declined,
      joinLinks: model.join_links,
      updatedBy: model.updated_by,
      updatedByName: model.updated_by_name,
      updatedOn: model.updated_on,
      name: model.name,
      description: model.description,
      type: model.type,
      startTime: model.start_time,
      endTime: model.end_time,
      repeat: model.repeat,
      invitees: model.invitees,
      createdOn: model.created_on,
      createdBy: model.created_by,
      createdByName: model.created_by_name,
      reminders: model.reminders,
      repeatUntil: model.repeat_until,
      isDeleted: model.is_deleted);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        companyId,
        apartmentId,
        startTime,
        endTime,
        repeat,
        invitees,
        accepted,
        declined,
        joinLinks,
        createdBy,
        createdOn,
        createdByName,
        reminders,
        repeatUntil,
        updatedBy,
        updatedByName,
        updatedOn,
        isDeleted
      ];
}

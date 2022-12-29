import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/event/entities/event.dart';
import 'package:priorli/core/event/repos/event_repository.dart';

import '../entities/event_type.dart';
import '../entities/repeat.dart';

class CreateEvent extends UseCase<Event, CreateEventParams> {
  final EventRepository eventRepository;

  CreateEvent({required this.eventRepository});
  @override
  Future<Result<Event>> call(CreateEventParams params) {
    return eventRepository.createEvent(
        name: params.name,
        description: params.description,
        startTime: params.startTime,
        endTime: params.endTime,
        type: params.type,
        reminders: params.reminders,
        repeatUntil: params.repeatUntil,
        invitees: params.invitees,
        repeat: params.repeat,
        companyId: params.companyId,
        apartmentId: params.apartmentId);
  }
}

class CreateEventParams extends Equatable {
  final String name;
  final String description;
  final int startTime;
  final int endTime;
  final EventType type;
  final int? repeatUntil;
  final List<int>? reminders;
  final List<String>? invitees;
  final Repeat? repeat;
  final String? companyId;
  final String? apartmentId;

  const CreateEventParams(
      {required this.name,
      required this.description,
      required this.startTime,
      required this.endTime,
      required this.type,
      this.reminders,
      this.repeatUntil,
      this.invitees,
      this.repeat,
      this.companyId,
      this.apartmentId});
  @override
  List<Object?> get props => [
        name,
        description,
        startTime,
        endTime,
        type,
        invitees,
        repeat,
        companyId,
        apartmentId,
        reminders,
        repeatUntil
      ];
}

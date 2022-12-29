import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/event.dart';
import '../entities/event_type.dart';
import '../entities/repeat.dart';
import '../repos/event_repository.dart';

class EditEvent extends UseCase<Event, EditEventParams> {
  final EventRepository eventRepository;

  EditEvent({required this.eventRepository});
  @override
  Future<Result<Event>> call(EditEventParams params) {
    return eventRepository.editEvent(
        eventId: params.eventId,
        name: params.name,
        description: params.description,
        startTime: params.startTime,
        endTime: params.endTime,
        repeat: params.repeat,
        type: params.type,
        companyId: params.companyId,
        apartmentId: params.apartmentId,
        deleted: params.deleted,
        reminders: params.reminders,
        repeatUntil: params.repeatUntil,
        additionInvitees: params.additionInvitees);
  }
}

class EditEventParams extends Equatable {
  final String eventId;
  final String? name;
  final String? description;
  final int? startTime;
  final int? endTime;
  final Repeat? repeat;
  final EventType? type;
  final String? companyId;
  final String? apartmentId;
  final bool? deleted;
  final List<String>? additionInvitees;
  final int? repeatUntil;
  final List<int>? reminders;

  const EditEventParams(
      {required this.eventId,
      this.name,
      this.reminders,
      this.repeatUntil,
      this.description,
      this.startTime,
      this.endTime,
      this.repeat,
      this.type,
      this.companyId,
      this.apartmentId,
      this.deleted,
      this.additionInvitees});
  @override
  List<Object?> get props => [
        eventId,
        name,
        description,
        startTime,
        endTime,
        repeat,
        reminders,
        repeatUntil,
        type,
        companyId,
        apartmentId,
        deleted,
        additionInvitees
      ];
}

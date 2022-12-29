import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/event.dart';
import '../repos/event_repository.dart';

class InviteToEvent extends UseCase<Event, InviteToEventParams> {
  final EventRepository eventRepository;

  InviteToEvent({required this.eventRepository});
  @override
  Future<Result<Event>> call(InviteToEventParams params) {
    return eventRepository.editEvent(
        eventId: params.eventId, additionInvitees: params.additionInvitees);
  }
}

class InviteToEventParams extends Equatable {
  final String eventId;
  final List<String> additionInvitees;

  const InviteToEventParams(
      {required this.eventId, required this.additionInvitees});
  @override
  List<Object?> get props => [eventId, additionInvitees];
}

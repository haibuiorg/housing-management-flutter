import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/event.dart';
import '../repos/event_repository.dart';

class RemoveUserFromEvent extends UseCase<Event, RemoveUserFromEventParams> {
  final EventRepository eventRepository;

  RemoveUserFromEvent({required this.eventRepository});
  @override
  Future<Result<Event>> call(RemoveUserFromEventParams params) {
    return eventRepository.removeFromFromEvent(
        removedUsers: params.removedUsers, eventId: params.eventId);
  }
}

class RemoveUserFromEventParams extends Equatable {
  final List<String> removedUsers;
  final String eventId;

  const RemoveUserFromEventParams(
      {required this.removedUsers, required this.eventId});
  @override
  List<Object?> get props => [removedUsers, eventId];
}

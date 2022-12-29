import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/event.dart';
import '../repos/event_repository.dart';

class ResponseToEvent extends UseCase<Event, ResponseToEventParams> {
  final EventRepository eventRepository;

  ResponseToEvent({required this.eventRepository});
  @override
  Future<Result<Event>> call(ResponseToEventParams params) {
    return eventRepository.responseToEvent(
        accepted: params.accepted, eventId: params.eventId);
  }
}

class ResponseToEventParams extends Equatable {
  final String eventId;
  final bool? accepted;

  const ResponseToEventParams({required this.eventId, this.accepted});
  @override
  List<Object?> get props => [accepted, eventId];
}

import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/event.dart';
import '../repos/event_repository.dart';

class GetEvent extends UseCase<Event, GetEventParams> {
  final EventRepository eventRepository;

  GetEvent({required this.eventRepository});
  @override
  Future<Result<Event>> call(GetEventParams params) {
    return eventRepository.getEvent(id: params.id);
  }
}

class GetEventParams extends Equatable {
  final String id;

  const GetEventParams({required this.id});
  @override
  List<Object?> get props => [id];
}

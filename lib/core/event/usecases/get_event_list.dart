import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/event.dart';
import '../entities/event_type.dart';
import '../repos/event_repository.dart';

class GetEventList extends UseCase<List<Event>, GetEventListParams> {
  final EventRepository eventRepository;

  GetEventList({required this.eventRepository});
  @override
  Future<Result<List<Event>>> call(GetEventListParams params) {
    return eventRepository.getEventList(
        companyId: params.companyId,
        apartmentId: params.apartmentId,
        types: params.types,
        includePastEvent: params.includePastEvent,
        lastCreatedOn: params.lastCreatedOn,
        limit: params.limit);
  }
}

class GetEventListParams extends Equatable {
  final String? companyId;
  final String? apartmentId;
  final List<EventType>? types;
  final bool? includePastEvent;
  final int? lastCreatedOn;
  final int? limit;

  const GetEventListParams(
      {this.companyId,
      this.apartmentId,
      this.types,
      this.includePastEvent,
      this.lastCreatedOn,
      this.limit});
  @override
  List<Object?> get props =>
      [companyId, apartmentId, types, includePastEvent, lastCreatedOn, limit];
}

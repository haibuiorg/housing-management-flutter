import 'package:priorli/core/event/data/event_data_source.dart';
import 'package:priorli/core/event/entities/repeat.dart';
import 'package:priorli/core/event/entities/event_type.dart';
import 'package:priorli/core/event/entities/event.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/event/repos/event_repository.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';

class EventRepositoryImpl implements EventRepository {
  final EventDataSource eventRemoteDataSource;

  EventRepositoryImpl({required this.eventRemoteDataSource});
  @override
  Future<Result<Event>> createEvent(
      {required String name,
      required String description,
      required int startTime,
      required int endTime,
      required EventType type,
      int? repeatUntil,
      List<int>? reminders,
      List<String>? invitees,
      Repeat? repeat,
      String? companyId,
      String? apartmentId}) async {
    try {
      final eventModel = await eventRemoteDataSource.createEvent(
          name: name,
          description: description,
          startTime: startTime,
          endTime: endTime,
          reminders: reminders,
          repeatUntil: repeatUntil,
          type: type,
          invitees: invitees,
          repeat: repeat,
          companyId: companyId,
          apartmentId: apartmentId);
      return ResultSuccess(Event.modelToEntity(eventModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Event>> editEvent(
      {required String eventId,
      String? name,
      String? description,
      int? startTime,
      int? endTime,
      Repeat? repeat,
      int? repeatUntil,
      List<int>? reminders,
      EventType? type,
      String? companyId,
      String? apartmentId,
      bool? deleted,
      List<String>? additionInvitees}) async {
    try {
      final eventModel = await eventRemoteDataSource.editEvent(
          name: name,
          description: description,
          startTime: startTime,
          endTime: endTime,
          type: type,
          reminders: reminders,
          repeatUntil: repeatUntil,
          additionInvitees: additionInvitees,
          repeat: repeat,
          companyId: companyId,
          apartmentId: apartmentId,
          eventId: eventId,
          deleted: deleted);
      return ResultSuccess(Event.modelToEntity(eventModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Event>> getEvent({required String id}) async {
    try {
      final eventModel = await eventRemoteDataSource.getEvent(id: id);
      return ResultSuccess(Event.modelToEntity(eventModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<Event>>> getEventList(
      {String? companyId,
      String? apartmentId,
      List<EventType>? types,
      bool? includePastEvent,
      int? lastCreatedOn,
      int? limit}) async {
    try {
      final eventModels = await eventRemoteDataSource.getEventList(
          lastCreatedOn: lastCreatedOn,
          includePastEvent: includePastEvent,
          limit: limit,
          types: types,
          companyId: companyId,
          apartmentId: apartmentId);
      return ResultSuccess(
          eventModels.map((e) => Event.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Event>> removeFromFromEvent(
      {required List<String> removedUsers, required String eventId}) async {
    try {
      final eventModel = await eventRemoteDataSource.removeFromFromEvent(
          eventId: eventId, removedUsers: removedUsers);
      return ResultSuccess(Event.modelToEntity(eventModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Event>> responseToEvent(
      {bool? accepted, required String eventId}) async {
    try {
      final eventModel = await eventRemoteDataSource.responseToEvent(
          eventId: eventId, accepted: accepted);
      return ResultSuccess(Event.modelToEntity(eventModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

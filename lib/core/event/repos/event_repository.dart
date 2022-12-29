import 'package:priorli/core/base/result.dart';

import '../entities/event.dart';
import '../entities/event_type.dart';
import '../entities/repeat.dart';

abstract class EventRepository {
  Future<Result<List<Event>>> getEventList(
      {String? companyId,
      String? apartmentId,
      List<EventType>? types,
      bool? includePastEvent,
      int? lastCreatedOn,
      int? limit});
  Future<Result<Event>> getEvent({required String id});
  Future<Result<Event>> createEvent({
    required String name,
    required String description,
    required int startTime,
    required int endTime,
    required EventType type,
    List<String>? invitees,
    int? repeatUntil,
    List<int>? reminders,
    Repeat? repeat,
    String? companyId,
    String? apartmentId,
  });
  Future<Result<Event>> editEvent(
      {required String eventId,
      String? name,
      String? description,
      int? startTime,
      int? endTime,
      Repeat? repeat,
      EventType? type,
      String? companyId,
      String? apartmentId,
      int? repeatUntil,
      List<int>? reminders,
      bool? deleted,
      List<String>? additionInvitees});
  Future<Result<Event>> removeFromFromEvent(
      {required List<String> removedUsers, required String eventId});
  Future<Result<Event>> responseToEvent(
      {bool? accepted, required String eventId});
}

import 'package:priorli/core/event/entities/event_type.dart';
import 'package:priorli/core/event/entities/repeat.dart';
import 'package:priorli/core/event/models/event_model.dart';

abstract class EventDataSource {
  Future<List<EventModel>> getEventList(
      {String? companyId,
      String? apartmentId,
      List<EventType>? types,
      bool? includePastEvent,
      int? lastCreatedOn,
      int? limit});
  Future<EventModel> getEvent({required String id});
  Future<EventModel> createEvent({
    required String name,
    required String description,
    required int startTime,
    required int endTime,
    required EventType type,
    List<String>? invitees,
    Repeat? repeat,
    int? repeatUntil,
    List<int>? reminders,
    String? companyId,
    String? apartmentId,
  });
  Future<EventModel> editEvent(
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
  Future<EventModel> removeFromFromEvent(
      {required List<String> removedUsers, required String eventId});
  Future<EventModel> responseToEvent({bool? accepted, required String eventId});
}

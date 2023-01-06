import 'package:dio/dio.dart';
import 'package:priorli/core/event/data/event_data_source.dart';
import 'package:priorli/core/event/entities/repeat.dart';
import 'package:priorli/core/event/entities/event_type.dart';
import 'package:priorli/core/utils/string_extension.dart';

import '../../base/exceptions.dart';
import '../models/event_model.dart';

class EventRemoteDataSource implements EventDataSource {
  final Dio client;

  EventRemoteDataSource({required this.client});

  @override
  Future<EventModel> createEvent(
      {required String name,
      required String description,
      required int startTime,
      required int endTime,
      required EventType type,
      List<String>? invitees,
      Repeat? repeat,
      String? companyId,
      int? repeatUntil,
      List<int>? reminders,
      String? apartmentId}) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'start_time': startTime,
        'end_time': endTime,
        'type': type.name.camelCaseToUnderScore(),
        'invitees': invitees,
        'repeat': repeat?.name.camelCaseToUnderScore(),
        'company_id': companyId,
        'repeat_until': repeatUntil,
        'reminders': reminders,
        'apartment_id': apartmentId,
      };
      final result = await client.post('/event', data: data);
      return EventModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<EventModel> editEvent(
      {required String eventId,
      String? name,
      String? description,
      int? startTime,
      int? endTime,
      Repeat? repeat,
      EventType? type,
      String? companyId,
      int? repeatUntil,
      List<int>? reminders,
      String? apartmentId,
      bool? deleted,
      List<String>? additionInvitees}) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'start_time': startTime,
        'end_time': endTime,
        'repeat_until': repeatUntil,
        'reminders': reminders,
        'type': type?.name.camelCaseToUnderScore(),
        'addition_invitees': additionInvitees,
        'repeat': repeat?.name.camelCaseToUnderScore(),
        'company_id': companyId,
        'deleted': deleted,
        'apartment_id': apartmentId,
      };
      final result = await client.put('/event/$eventId', data: data);
      return EventModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<EventModel> getEvent({required String id}) async {
    try {
      final result = await client.get(
        '/event/$id',
      );
      return EventModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<EventModel>> getEventList(
      {String? companyId,
      String? apartmentId,
      List<EventType>? types,
      bool? includePastEvent,
      int? lastCreatedOn,
      int? limit}) async {
    try {
      final data = {
        'company_id': companyId,
        'apartment_id': apartmentId,
        'types': types?.map((e) => e.name.camelCaseToUnderScore()).toList(),
        'include_past_event': includePastEvent,
        'last_created_on': lastCreatedOn,
        'limit': limit,
      };
      data.removeWhere((key, value) => value == null);
      final result = await client.get('/events', queryParameters: data);
      return (result.data as List<dynamic>)
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<EventModel> removeFromFromEvent(
      {required List<String> removedUsers, required String eventId}) async {
    try {
      final data = {
        'removed_users': removedUsers,
      };
      final result =
          await client.put('/event/$eventId/remove_users', data: data);
      return EventModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<EventModel> responseToEvent(
      {bool? accepted, required String eventId}) async {
    try {
      final data = {
        'accepted': accepted,
      };
      final result = await client.put('/event/$eventId/response', data: data);
      return EventModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

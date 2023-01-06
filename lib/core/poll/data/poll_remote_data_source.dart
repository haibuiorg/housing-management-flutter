import 'package:dio/dio.dart';
import 'package:priorli/core/poll/data/poll_data_source.dart';
import 'package:priorli/core/poll/models/poll_model.dart';
import 'package:priorli/core/utils/string_extension.dart';

import '../../base/exceptions.dart';
import '../entities/poll_type.dart';

class PollRemoteDataSource implements PollDataSource {
  final Dio client;

  PollRemoteDataSource({required this.client});
  @override
  Future<PollModel> addPollOption(
      {required List<String> votingOptions, required String pollId}) async {
    try {
      final data = {'voting_options': votingOptions};
      final result = await client.put('/poll/$pollId/add', data: data);
      return PollModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<PollModel> createPoll(
      {required String name,
      required String description,
      required PollType type,
      required List<String> invitess,
      bool? expandable,
      bool? annonymous,
      String? companyId,
      int? endedOn,
      bool? multiple,
      required List<String> votingOptions}) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'type': type.name.camelCaseToUnderScore(),
        'expandable': expandable,
        'annonymous': annonymous,
        'invitees': invitess,
        'ended_on': endedOn,
        'company_id': companyId,
        'multiple': multiple,
        'voting_options': votingOptions
      };
      final result = await client.post('/poll', data: data);
      return PollModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<PollModel> getPoll({required String id}) async {
    try {
      final result = await client.put('/poll/$id');
      return PollModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<PollModel>> getPollList(
      {String? companyId,
      List<PollType>? types,
      bool? includeEndedPoll,
      int? lastCreatedOn,
      int? limit}) async {
    try {
      final data = {
        'company_id': companyId,
        'types': types?.map((e) => e.name.camelCaseToUnderScore()).toList(),
        'include_ended_poll': includeEndedPoll,
        'last_created_on': lastCreatedOn,
        'limit': limit,
      };
      data.removeWhere((key, value) => value == null);
      final result = await client.get('/polls', queryParameters: data);
      return (result.data as List<dynamic>)
          .map((e) => PollModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<PollModel> removePollOption(
      {required String votingOptionId, required String pollId}) async {
    try {
      final data = {'voting_option_id': votingOptionId};
      final result = await client.put('/poll/$pollId/remove', data: data);
      return PollModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<PollModel> selectPollOption(
      {required String votingOptionId, required String pollId}) async {
    try {
      final data = {'voting_option_id': votingOptionId};
      final result = await client.put('/poll/$pollId/select', data: data);
      return PollModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<PollModel> editPoll(
      {String? name,
      required String pollId,
      String? description,
      bool? expandable,
      String? companyId,
      int? endedOn,
      bool? multiple,
      List<String>? additionInvitees,
      bool? deleted}) async {
    try {
      final data = {
        'name': name,
        'description': description,
        'expandable': expandable,
        'addition_invitees': additionInvitees,
        'ended_on': endedOn,
        'company_id': companyId,
        'multiple': multiple,
        'deleted': deleted
      };
      final result = await client.put('/poll/$pollId', data: data);
      return PollModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

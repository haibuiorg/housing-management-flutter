import 'package:priorli/core/poll/entities/poll_type.dart';
import 'package:priorli/core/poll/models/poll_model.dart';

abstract class PollDataSource {
  Future<List<PollModel>> getPollList(
      {String? companyId,
      List<PollType>? types,
      bool? includeEndedPoll,
      int? lastCreatedOn,
      int? limit});
  Future<PollModel> getPoll({required String id});
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
      required List<String> votingOptions});
  Future<PollModel> editPoll(
      {String? name,
      String? description,
      bool? expandable,
      String? companyId,
      int? endedOn,
      bool? multiple,
      required String pollId,
      List<String>? additionInvitees,
      bool? deleted});
  Future<PollModel> addPollOption(
      {required String pollId, required List<String> votingOptions});
  Future<PollModel> removePollOption(
      {required String votingOptionId, required String pollId});
  Future<PollModel> selectPollOption(
      {required String votingOptionId, required String pollId});
}

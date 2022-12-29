import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/entities/poll_type.dart';

abstract class PollRepository {
  Future<Result<List<Poll>>> getPollList(
      {String? companyId,
      List<PollType>? types,
      bool? includeEndedPoll,
      int? lastCreatedOn,
      int? limit});
  Future<Result<Poll>> getPoll({required String id});
  Future<Result<Poll>> createPoll(
      {required String name,
      required String description,
      required PollType type,
      required List<String> invitees,
      bool? expandable,
      bool? annonymous,
      required String companyId,
      int? endedOn,
      bool? multiple,
      required List<String> votingOptions});
  Future<Result<Poll>> editPoll(
      {String? name,
      String? description,
      bool? expandable,
      String? companyId,
      int? endedOn,
      bool? multiple,
      required String pollId,
      List<String>? additionInvitees,
      bool? deleted});
  Future<Result<Poll>> addPollOption(
      {required List<String> votingOptions, required String pollId});
  Future<Result<Poll>> removePollOption(
      {required String votingOptionId, required String pollId});
  Future<Result<Poll>> selectPollOption(
      {required String votingOptionId, required String pollId});
}

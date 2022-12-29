import 'package:priorli/core/poll/data/poll_data_source.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/poll/entities/poll_type.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';

class PollRepositoryImpl implements PollRepository {
  final PollDataSource pollRemoteDataSource;

  PollRepositoryImpl({required this.pollRemoteDataSource});

  @override
  Future<Result<Poll>> addPollOption(
      {required List<String> votingOptions, required String pollId}) async {
    try {
      final pollModel = await pollRemoteDataSource.addPollOption(
          pollId: pollId, votingOptions: votingOptions);
      return ResultSuccess(Poll.modelToEntity(pollModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
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
      required List<String> votingOptions}) async {
    try {
      final pollModel = await pollRemoteDataSource.createPoll(
          name: name,
          description: description,
          endedOn: endedOn,
          expandable: expandable,
          type: type,
          invitess: invitees,
          annonymous: annonymous,
          companyId: companyId,
          votingOptions: votingOptions,
          multiple: multiple);
      return ResultSuccess(Poll.modelToEntity(pollModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Poll>> getPoll({required String id}) async {
    try {
      final pollModel = await pollRemoteDataSource.getPoll(id: id);
      return ResultSuccess(Poll.modelToEntity(pollModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<Poll>>> getPollList(
      {String? companyId,
      List<PollType>? types,
      bool? includeEndedPoll,
      int? lastCreatedOn,
      int? limit}) async {
    try {
      final pollModels = await pollRemoteDataSource.getPollList(
        includeEndedPoll: includeEndedPoll,
        types: types,
        lastCreatedOn: lastCreatedOn,
        limit: limit,
        companyId: companyId,
      );
      return ResultSuccess(
          pollModels.map((e) => Poll.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Poll>> removePollOption(
      {required String votingOptionId, required String pollId}) async {
    try {
      final pollModel = await pollRemoteDataSource.removePollOption(
          pollId: pollId, votingOptionId: votingOptionId);
      return ResultSuccess(Poll.modelToEntity(pollModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Poll>> selectPollOption(
      {required String votingOptionId, required String pollId}) async {
    try {
      final pollModel = await pollRemoteDataSource.selectPollOption(
          pollId: pollId, votingOptionId: votingOptionId);
      return ResultSuccess(Poll.modelToEntity(pollModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Poll>> editPoll(
      {String? name,
      String? description,
      bool? expandable,
      String? companyId,
      int? endedOn,
      bool? multiple,
      required String pollId,
      List<String>? additionInvitees,
      bool? deleted}) async {
    try {
      final pollModel = await pollRemoteDataSource.editPoll(
          name: name,
          description: description,
          endedOn: endedOn,
          expandable: expandable,
          deleted: deleted,
          companyId: companyId,
          pollId: pollId,
          additionInvitees: additionInvitees,
          multiple: multiple);
      return ResultSuccess(Poll.modelToEntity(pollModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

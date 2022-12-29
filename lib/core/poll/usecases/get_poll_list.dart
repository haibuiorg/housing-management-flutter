import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';

import '../entities/poll_type.dart';

class GetPollList extends UseCase<List<Poll>, GetPollListParams> {
  final PollRepository pollRepository;

  GetPollList({required this.pollRepository});

  @override
  Future<Result<List<Poll>>> call(GetPollListParams params) {
    return pollRepository.getPollList(
        companyId: params.companyId,
        types: params.types,
        includeEndedPoll: params.includeEndedPoll,
        lastCreatedOn: params.lastCreatedOn,
        limit: params.limit);
  }
}

class GetPollListParams extends Equatable {
  final String? companyId;
  final List<PollType>? types;
  final bool? includeEndedPoll;
  final int? lastCreatedOn;
  final int? limit;

  const GetPollListParams(
      {this.companyId,
      this.types,
      this.includeEndedPoll,
      this.lastCreatedOn,
      this.limit});
  @override
  List<Object?> get props =>
      [companyId, types, includeEndedPoll, lastCreatedOn, limit];
}

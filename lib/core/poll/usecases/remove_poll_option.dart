import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';

class RemovePollOption extends UseCase<Poll, RemovePollOptionParams> {
  final PollRepository pollRepository;

  RemovePollOption({required this.pollRepository});

  @override
  Future<Result<Poll>> call(RemovePollOptionParams params) {
    return pollRepository.removePollOption(
        votingOptionId: params.votingOptionId, pollId: params.pollId);
  }
}

class RemovePollOptionParams extends Equatable {
  final String votingOptionId;
  final String pollId;

  const RemovePollOptionParams(
      {required this.votingOptionId, required this.pollId});
  @override
  List<Object?> get props => [pollId, votingOptionId];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';

class SelectPollOption extends UseCase<Poll, SelectPollOptionParams> {
  final PollRepository pollRepository;

  SelectPollOption({required this.pollRepository});

  @override
  Future<Result<Poll>> call(SelectPollOptionParams params) {
    return pollRepository.selectPollOption(
        votingOptionId: params.votingOptionId, pollId: params.pollId);
  }
}

class SelectPollOptionParams extends Equatable {
  final String votingOptionId;
  final String pollId;

  const SelectPollOptionParams(
      {required this.votingOptionId, required this.pollId});
  @override
  List<Object?> get props => [votingOptionId, pollId];
}

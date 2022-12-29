import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';

class AddPollOption extends UseCase<Poll, AddPollOptionParams> {
  final PollRepository pollRepository;

  AddPollOption({required this.pollRepository});

  @override
  Future<Result<Poll>> call(AddPollOptionParams params) {
    return pollRepository.addPollOption(
        votingOptions: params.votingOptions, pollId: params.pollId);
  }
}

class AddPollOptionParams extends Equatable {
  final List<String> votingOptions;
  final String pollId;

  const AddPollOptionParams(
      {required this.votingOptions, required this.pollId});
  @override
  List<Object?> get props => [pollId, votingOptions];
}

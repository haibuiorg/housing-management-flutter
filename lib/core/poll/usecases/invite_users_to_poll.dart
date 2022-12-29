import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';

class InviteUsersToPoll extends UseCase<Poll, InviteUsersToPollParams> {
  final PollRepository pollRepository;

  InviteUsersToPoll({required this.pollRepository});

  @override
  Future<Result<Poll>> call(InviteUsersToPollParams params) {
    return pollRepository.editPoll(
        pollId: params.pollId, additionInvitees: params.additionInvitees);
  }
}

class InviteUsersToPollParams extends Equatable {
  final String pollId;
  final List<String> additionInvitees;

  const InviteUsersToPollParams(
      {required this.pollId, required this.additionInvitees});
  @override
  List<Object?> get props => [pollId, additionInvitees];
}

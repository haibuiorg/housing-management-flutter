import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';

class GetPoll extends UseCase<Poll, GetPollParams> {
  final PollRepository pollRepository;

  GetPoll({required this.pollRepository});

  @override
  Future<Result<Poll>> call(GetPollParams params) {
    return pollRepository.getPoll(id: params.id);
  }
}

class GetPollParams extends Equatable {
  final String id;

  const GetPollParams({required this.id});
  @override
  List<Object?> get props => [id];
}

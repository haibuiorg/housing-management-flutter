import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';

import '../entities/poll_type.dart';

class CreatePoll extends UseCase<Poll, CreatePollParams> {
  final PollRepository pollRepository;

  CreatePoll({required this.pollRepository});

  @override
  Future<Result<Poll>> call(CreatePollParams params) {
    return pollRepository.createPoll(
      name: params.name,
      description: params.description,
      type: params.type,
      invitees: params.invitees,
      companyId: params.companyId,
      votingOptions: params.votingOptions,
      multiple: params.multiple,
      endedOn: params.endedOn,
      expandable: params.expandable,
      annonymous: params.annonymous,
    );
  }
}

class CreatePollParams extends Equatable {
  final String name;
  final String description;
  final PollType type;
  final List<String> invitees;
  final bool? expandable;
  final bool? annonymous;
  final String companyId;
  final int? endedOn;
  final bool? multiple;
  final List<String> votingOptions;

  const CreatePollParams(
      {required this.name,
      required this.description,
      required this.type,
      required this.invitees,
      this.expandable,
      this.annonymous,
      required this.companyId,
      this.endedOn,
      this.multiple,
      required this.votingOptions});
  @override
  List<Object?> get props => [
        name,
        description,
        type,
        invitees,
        expandable,
        annonymous,
        companyId,
        endedOn,
        multiple,
        votingOptions
      ];
}

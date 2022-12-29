import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/repos/poll_repository.dart';

class EditPoll extends UseCase<Poll, EditPollParams> {
  final PollRepository pollRepository;

  EditPoll({required this.pollRepository});

  @override
  Future<Result<Poll>> call(EditPollParams params) {
    return pollRepository.editPoll(
        pollId: params.pollId,
        name: params.name,
        description: params.description,
        expandable: params.expandable,
        companyId: params.companyId,
        endedOn: params.endedOn,
        multiple: params.multiple,
        additionInvitees: params.additionInvitees,
        deleted: params.deleted);
  }
}

class EditPollParams extends Equatable {
  final String? name;
  final String? description;
  final bool? expandable;
  final String? companyId;
  final int? endedOn;
  final bool? multiple;
  final String pollId;
  final List<String>? additionInvitees;
  final bool? deleted;

  EditPollParams(
      {this.name,
      this.description,
      this.expandable,
      this.companyId,
      this.endedOn,
      this.multiple,
      required this.pollId,
      this.additionInvitees,
      this.deleted});
  @override
  List<Object?> get props => [
        pollId,
        name,
        description,
        expandable,
        companyId,
        endedOn,
        multiple,
        additionInvitees,
        deleted
      ];
}

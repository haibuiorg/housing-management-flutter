import 'package:equatable/equatable.dart';
import 'package:priorli/core/poll/entities/poll_type.dart';
import 'package:priorli/core/poll/models/poll_model.dart';

import 'voting_option.dart';

class Poll extends Equatable {
  final String id;
  final String name;
  final PollType type;
  final String description;
  final bool expandable;
  final bool annonymous;
  final bool deleted;
  final bool multiple;
  final int createdOn;
  final String? companyId;
  final int endedOn;
  final int? updatedOn;
  final List<String> invitees;
  final List<VotingOption> votingOptions;
  final String createdBy;
  final String createdByName;
  final String? updatedBy;
  final String? updatedByName;

  const Poll(
      {required this.id,
      required this.name,
      required this.type,
      required this.description,
      required this.expandable,
      required this.annonymous,
      required this.deleted,
      required this.multiple,
      required this.createdOn,
      this.companyId,
      required this.endedOn,
      this.updatedOn,
      required this.invitees,
      required this.votingOptions,
      required this.createdBy,
      required this.createdByName,
      this.updatedBy,
      this.updatedByName});

  factory Poll.modelToEntity(PollModel model) => Poll(
      id: model.id,
      name: model.name,
      type: model.type,
      description: model.description,
      expandable: model.expandable,
      annonymous: model.annonymous,
      deleted: model.deleted,
      multiple: model.multiple,
      createdOn: model.created_on,
      endedOn: model.ended_on,
      invitees: model.invitees,
      votingOptions: model.voting_options
          .map((e) => VotingOption.modelToEntity(e))
          .toList(),
      createdBy: model.created_by,
      createdByName: model.created_by_name,
      updatedBy: model.updated_by,
      updatedByName: model.updated_by_name,
      updatedOn: model.updated_on,
      companyId: model.company_id);

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        description,
        expandable,
        annonymous,
        deleted,
        multiple,
        createdOn,
        companyId,
        endedOn,
        invitees,
        updatedOn,
        votingOptions,
        createdBy,
        createdByName,
        updatedBy,
        updatedByName
      ];
}

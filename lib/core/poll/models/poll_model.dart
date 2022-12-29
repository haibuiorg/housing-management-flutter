// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/poll/entities/poll_type.dart';
import 'package:priorli/core/poll/models/voting_option_model.dart';

part 'poll_model.g.dart';

@JsonSerializable()
class PollModel extends Equatable {
  final String id;
  final String name;
  final PollType type; // 'generic'|'company_internal'|'company'| 'message',
  final String description;
  final bool expandable;
  final bool annonymous;
  final bool deleted;
  final bool multiple;
  final int created_on;
  final String? company_id;
  final int ended_on;
  final int? updated_on;
  final List<String> invitees;
  final List<VotingOptionModel> voting_options;
  final String created_by;
  final String created_by_name;
  final String? updated_by;
  final String? updated_by_name;

  const PollModel(
      {required this.id,
      required this.name,
      required this.type,
      required this.description,
      required this.expandable,
      required this.annonymous,
      required this.deleted,
      required this.multiple,
      required this.created_on,
      this.company_id,
      required this.ended_on,
      this.updated_on,
      required this.invitees,
      required this.voting_options,
      required this.created_by,
      required this.created_by_name,
      this.updated_by,
      this.updated_by_name});

  factory PollModel.fromJson(Map<String, dynamic> json) =>
      _$PollModelFromJson(json);

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
        created_on,
        company_id,
        ended_on,
        updated_on,
        invitees,
        voting_options,
        created_by,
        created_by_name,
        updated_by,
        updated_by_name
      ];
}

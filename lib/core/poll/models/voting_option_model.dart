// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'voting_option_model.g.dart';

@JsonSerializable()
class VotingOptionModel extends Equatable {
  final int id;
  final String description;
  final String added_by_name;
  final String added_by_user_id;
  final List<String> voters;

  const VotingOptionModel(
      {required this.id,
      required this.description,
      required this.added_by_name,
      required this.added_by_user_id,
      required this.voters});

  factory VotingOptionModel.fromJson(Map<String, dynamic> json) =>
      _$VotingOptionModelFromJson(json);

  @override
  List<Object?> get props =>
      [id, description, added_by_name, added_by_user_id, voters];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/poll/models/voting_option_model.dart';

class VotingOption extends Equatable {
  final int id;
  final String description;
  final String addedByName;
  final String addedByUserId;
  final List<String> voters;

  const VotingOption(
      {required this.id,
      required this.description,
      required this.addedByName,
      required this.addedByUserId,
      required this.voters});

  factory VotingOption.modelToEntity(VotingOptionModel model) => VotingOption(
      id: model.id,
      description: model.description,
      addedByName: model.added_by_name,
      addedByUserId: model.added_by_user_id,
      voters: model.voters);

  @override
  List<Object?> get props =>
      [id, description, addedByName, addedByUserId, voters];
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voting_option_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VotingOptionModel _$VotingOptionModelFromJson(Map<String, dynamic> json) =>
    VotingOptionModel(
      id: json['id'] as int,
      description: json['description'] as String,
      added_by_name: json['added_by_name'] as String,
      added_by_user_id: json['added_by_user_id'] as String,
      voters:
          (json['voters'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$VotingOptionModelToJson(VotingOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'added_by_name': instance.added_by_name,
      'added_by_user_id': instance.added_by_user_id,
      'voters': instance.voters,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollModel _$PollModelFromJson(Map<String, dynamic> json) => PollModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$PollTypeEnumMap, json['type']),
      description: json['description'] as String,
      expandable: json['expandable'] as bool,
      annonymous: json['annonymous'] as bool,
      deleted: json['deleted'] as bool,
      multiple: json['multiple'] as bool,
      created_on: json['created_on'] as int,
      company_id: json['company_id'] as String?,
      ended_on: json['ended_on'] as int,
      updated_on: json['updated_on'] as int?,
      invitees:
          (json['invitees'] as List<dynamic>).map((e) => e as String).toList(),
      voting_options: (json['voting_options'] as List<dynamic>)
          .map((e) => VotingOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      created_by: json['created_by'] as String,
      created_by_name: json['created_by_name'] as String,
      updated_by: json['updated_by'] as String?,
      updated_by_name: json['updated_by_name'] as String?,
    );

Map<String, dynamic> _$PollModelToJson(PollModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$PollTypeEnumMap[instance.type]!,
      'description': instance.description,
      'expandable': instance.expandable,
      'annonymous': instance.annonymous,
      'deleted': instance.deleted,
      'multiple': instance.multiple,
      'created_on': instance.created_on,
      'company_id': instance.company_id,
      'ended_on': instance.ended_on,
      'updated_on': instance.updated_on,
      'invitees': instance.invitees,
      'voting_options': instance.voting_options,
      'created_by': instance.created_by,
      'created_by_name': instance.created_by_name,
      'updated_by': instance.updated_by,
      'updated_by_name': instance.updated_by_name,
    };

const _$PollTypeEnumMap = {
  PollType.generic: 'generic',
  PollType.companyInternal: 'company_internal',
  PollType.company: 'company',
  PollType.message: 'message',
};

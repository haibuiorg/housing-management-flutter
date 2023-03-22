// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'legal_document_model.g.dart';

@JsonSerializable()
class LegalDocumentModel extends Equatable {
  final String id;
  final String type;
  final bool is_active;
  final int created_on;
  final String country_code;
  final String country_id;
  final String? storage_link;
  final String web_url;
  final String? url;

  const LegalDocumentModel({
    required this.id,
    required this.type,
    required this.is_active,
    required this.created_on,
    required this.country_code,
    required this.country_id,
    this.storage_link,
    required this.web_url,
    this.url,
  });

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$LegalDocumentModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        type,
        is_active,
        created_on,
        country_code,
        country_id,
        storage_link,
        web_url,
        url
      ];
}

// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_lead_model.g.dart';

@JsonSerializable()
class ContactLeadModel extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? message;
  final int? created_on;
  final String status;
  final String type;

  const ContactLeadModel({
    required this.id,
    this.name,
    this.email,
    this.message,
    this.created_on,
    this.phone,
    required this.status,
    required this.type,
  });

  factory ContactLeadModel.fromJson(Map<String, dynamic> json) =>
      _$ContactLeadModelFromJson(json);

  @override
  List<Object?> get props =>
      [id, name, email, message, created_on, type, status, phone];
}

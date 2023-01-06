// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice_group_model.g.dart';

@JsonSerializable()
class InvoiceGroupModel extends Equatable {
  final String id;
  final String invoice_name;
  final int payment_date;
  final bool is_deleted;
  final int created_on;
  final String company_id;
  final int number_of_invoices;

  const InvoiceGroupModel(
      {required this.id,
      required this.invoice_name,
      required this.payment_date,
      required this.is_deleted,
      required this.created_on,
      required this.company_id,
      required this.number_of_invoices});

  factory InvoiceGroupModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceGroupModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        invoice_name,
        payment_date,
        is_deleted,
        created_on,
        company_id,
        number_of_invoices
      ];
}

// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/invoice/entities/invoice_status.dart';

import 'invoice_item_model.dart';

part 'invoice_model.g.dart';

@JsonSerializable()
class InvoiceModel extends Equatable {
  final String id;
  final String group_id;
  final String? invoice_name;
  final double subtotal;
  final double paid;
  final String? reference_number;
  final List<InvoiceItemModel> items;
  final String receiver;
  final String? storage_link;
  final int payment_date;
  final dynamic virtual_barcode;
  final bool is_deleted;
  final int created_on;
  final String company_id;
  final InvoiceStatus status;
  final String? invoice_url;
  final int? invoice_url_expiration;

  const InvoiceModel(
      {required this.id,
      required this.invoice_name,
      required this.subtotal,
      required this.group_id,
      required this.paid,
      this.reference_number,
      required this.items,
      required this.receiver,
      this.storage_link,
      required this.payment_date,
      this.virtual_barcode,
      this.invoice_url,
      this.invoice_url_expiration,
      required this.is_deleted,
      required this.created_on,
      required this.company_id,
      required this.status});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        invoice_name,
        subtotal,
        paid,
        group_id,
        reference_number,
        items,
        receiver,
        storage_link,
        payment_date,
        virtual_barcode,
        is_deleted,
        created_on,
        company_id,
        status,
        invoice_url,
        invoice_url_expiration
      ];
}

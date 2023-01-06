import 'package:json_annotation/json_annotation.dart';

enum InvoiceStatus {
  @JsonValue('paid')
  paid,
  @JsonValue('pending')
  pending
}

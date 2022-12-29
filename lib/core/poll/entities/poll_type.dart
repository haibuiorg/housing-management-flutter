import 'package:json_annotation/json_annotation.dart';

enum PollType {
  // 'generic'|'company_internal'|'company'| 'message',
  @JsonValue('generic')
  generic,
  @JsonValue('company_internal')
  companyInternal,
  @JsonValue('company')
  company,
  @JsonValue('message')
  message,
}

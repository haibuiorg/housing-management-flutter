import 'package:json_annotation/json_annotation.dart';

enum EventType {
  //'generic'|'company_internal'|'company'|'apartment'|'personal',
  @JsonValue('generic')
  generic,
  @JsonValue('company_internal')
  companyInternal,
  @JsonValue('company')
  company,
  @JsonValue('apartment')
  apartment,
  @JsonValue('personal')
  personal;
}

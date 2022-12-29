import 'package:json_annotation/json_annotation.dart';

enum Repeat {
  @JsonValue('daily')
  daily,
  @JsonValue('weekday')
  weekday,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly;
}

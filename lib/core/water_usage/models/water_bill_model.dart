import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'water_bill_model.g.dart';

@JsonSerializable()
class WaterBillModel extends Equatable {
  final String id;
  final int period;
  final int year;
  final String url;
  final String consumption;
  @JsonKey(name: 'created_on')
  final int createdOn;

  const WaterBillModel(
      {required this.id,
      required this.period,
      required this.consumption,
      required this.year,
      required this.url,
      required this.createdOn});

  factory WaterBillModel.fromJson(Map<String, dynamic> json) =>
      _$WaterBillModelFromJson(json);

  @override
  List<Object?> get props => [id, year, period, url, createdOn];
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/water_usage/models/consumption_value_model.dart';

part 'water_consumption_model.g.dart';

@JsonSerializable()
class WaterConsumptionModel extends Equatable {
  final String id;
  @JsonKey(name: 'basice_fee')
  final double basicFee;
  final int period;
  @JsonKey(name: 'price_id')
  final String priceId;
  @JsonKey(name: 'price_per_cube')
  final double pricePerCube;
  @JsonKey(name: 'total_reading')
  final double totalReading;
  final int year;
  @JsonKey(name: 'consumption_values')
  final List<ConsumptionValueModel>? consumptionValues;

  const WaterConsumptionModel(
      {required this.id,
      required this.basicFee,
      required this.period,
      required this.priceId,
      required this.pricePerCube,
      required this.totalReading,
      required this.year,
      this.consumptionValues});

  factory WaterConsumptionModel.fromJson(Map<String, dynamic> json) =>
      _$WaterConsumptionModelFromJson(json);
  @override
  List<Object?> get props => [
        id,
        priceId,
        basicFee,
        period,
        year,
        pricePerCube,
        totalReading,
        consumptionValues
      ];
}

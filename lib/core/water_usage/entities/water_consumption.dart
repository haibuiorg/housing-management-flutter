import 'package:equatable/equatable.dart';
import 'package:priorli/core/water_usage/models/water_consumption_model.dart';

import 'consumption_value.dart';

class WaterConsumption extends Equatable {
  final String id;
  final double basicFee;
  final int period;
  final String priceId;
  final double pricePerCube;
  final double totalReading;
  final int year;
  final List<ConsumptionValue>? consumptionValues;

  const WaterConsumption(
      {required this.id,
      required this.basicFee,
      required this.period,
      required this.priceId,
      required this.pricePerCube,
      required this.totalReading,
      required this.year,
      this.consumptionValues});

  factory WaterConsumption.modelToEntity(WaterConsumptionModel model) =>
      WaterConsumption(
          id: model.id,
          basicFee: model.basicFee,
          period: model.period,
          priceId: model.priceId,
          pricePerCube: model.pricePerCube,
          totalReading: model.totalReading,
          year: model.year);
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

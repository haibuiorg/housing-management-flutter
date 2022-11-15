import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

class StartNewWaterConsumptionPeriod
    extends UseCase<WaterConsumption, StartNewWaterConsumptionPeriodParams> {
  final WaterUsageRepository waterUsageRepository;

  StartNewWaterConsumptionPeriod({required this.waterUsageRepository});
  @override
  Future<Result<WaterConsumption>> call(
      StartNewWaterConsumptionPeriodParams params) {
    return waterUsageRepository.startNewWaterConsumptionPeriod(
        housingCompanyId: params.housingCompanyId,
        totalReading: params.totalReading);
  }
}

class StartNewWaterConsumptionPeriodParams extends Equatable {
  final String housingCompanyId;
  final double totalReading;

  const StartNewWaterConsumptionPeriodParams(
      this.housingCompanyId, this.totalReading);
  @override
  List<Object?> get props => [housingCompanyId, totalReading];
}

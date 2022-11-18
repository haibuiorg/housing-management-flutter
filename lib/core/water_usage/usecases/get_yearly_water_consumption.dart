import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

class GetYearlyWaterConsumption
    extends UseCase<List<WaterConsumption>, GetYearlyWaterConsumptionParams> {
  final WaterUsageRepository waterUsageRepository;

  GetYearlyWaterConsumption({required this.waterUsageRepository});
  @override
  Future<Result<List<WaterConsumption>>> call(
      GetYearlyWaterConsumptionParams params) {
    return waterUsageRepository.getYearlyWaterConsumption(
        housingCompanyId: params.housingCompanyId, year: params.year);
  }
}

class GetYearlyWaterConsumptionParams extends Equatable {
  final String housingCompanyId;
  final int year;
  const GetYearlyWaterConsumptionParams({
    required this.housingCompanyId,
    required this.year,
  });

  @override
  List<Object?> get props => [housingCompanyId, year];
}

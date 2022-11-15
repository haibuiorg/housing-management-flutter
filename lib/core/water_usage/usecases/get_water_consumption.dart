import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

class GetWaterConsumption
    extends UseCase<WaterConsumption, GetWaterConsumptionParams> {
  final WaterUsageRepository waterUsageRepository;

  GetWaterConsumption({required this.waterUsageRepository});
  @override
  Future<Result<WaterConsumption>> call(GetWaterConsumptionParams params) {
    return waterUsageRepository.getWaterConsumption(
        housingCompanyId: params.housingCompanyId,
        year: params.year ?? 2022,
        period: params.period ?? 0);
  }
}

class GetWaterConsumptionParams extends Equatable {
  final String housingCompanyId;
  final int? year;
  final int? period;
  const GetWaterConsumptionParams({
    required this.housingCompanyId,
    this.year,
    this.period,
  });

  @override
  List<Object?> get props => [housingCompanyId, year, period];
}

import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

import 'get_water_consumption.dart';

class GetLatestWaterConsumption
    extends UseCase<WaterConsumption, GetWaterConsumptionParams> {
  final WaterUsageRepository waterUsageRepository;

  GetLatestWaterConsumption({required this.waterUsageRepository});
  @override
  Future<Result<WaterConsumption>> call(GetWaterConsumptionParams params) {
    return waterUsageRepository.getLatestWaterConsumption(
        housingCompanyId: params.housingCompanyId);
  }
}

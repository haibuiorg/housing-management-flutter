import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_price.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

class GetWaterPriceHistory
    extends UseCase<List<WaterPrice>, GetWaterPriceHistoryParams> {
  final WaterUsageRepository waterUsageRepository;

  GetWaterPriceHistory({required this.waterUsageRepository});
  @override
  Future<Result<List<WaterPrice>>> call(GetWaterPriceHistoryParams params) {
    return waterUsageRepository.getWaterPriceHistory(
        housingCompanyId: params.housingCompanyId);
  }
}

class GetWaterPriceHistoryParams extends Equatable {
  final String housingCompanyId;

  const GetWaterPriceHistoryParams({required this.housingCompanyId});
  @override
  List<Object?> get props => [housingCompanyId];
}

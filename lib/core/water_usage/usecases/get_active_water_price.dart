import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_price.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

class GetActiveWaterPrice
    extends UseCase<WaterPrice, GetActiveWaterPriceParams> {
  final WaterUsageRepository waterUsageRepository;

  GetActiveWaterPrice({required this.waterUsageRepository});
  @override
  Future<Result<WaterPrice>> call(GetActiveWaterPriceParams params) {
    return waterUsageRepository.getActiveWaterPrice(
        housingCompanyId: params.housingCompanyId);
  }
}

class GetActiveWaterPriceParams extends Equatable {
  final String housingCompanyId;

  const GetActiveWaterPriceParams({required this.housingCompanyId});
  @override
  List<Object?> get props => [housingCompanyId];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_price.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

class DeleteWaterPrice extends UseCase<WaterPrice, DeleteWaterPriceParams> {
  final WaterUsageRepository waterUsageRepository;

  DeleteWaterPrice({required this.waterUsageRepository});
  @override
  Future<Result<WaterPrice>> call(DeleteWaterPriceParams params) {
    return waterUsageRepository.deleteNewWaterPrice(
        housingCompanyId: params.housingCompanyId, id: params.id);
  }
}

class DeleteWaterPriceParams extends Equatable {
  final String housingCompanyId;
  final String id;

  const DeleteWaterPriceParams(
      {required this.housingCompanyId, required this.id});
  @override
  List<Object?> get props => [housingCompanyId, id];
}

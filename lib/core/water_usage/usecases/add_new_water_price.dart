import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_price.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

class AddNewWaterPrice extends UseCase<WaterPrice, AddNewWaterPriceParams> {
  final WaterUsageRepository waterUsageRepository;

  AddNewWaterPrice({required this.waterUsageRepository});
  @override
  Future<Result<WaterPrice>> call(AddNewWaterPriceParams params) {
    return waterUsageRepository.addNewWaterPrice(
        housingCompanyId: params.housingCompanyId,
        basicFee: params.basicFee,
        pricePerCube: params.pricePerCube);
  }
}

class AddNewWaterPriceParams extends Equatable {
  final String housingCompanyId;
  final double basicFee;
  final double pricePerCube;

  const AddNewWaterPriceParams(
      {required this.housingCompanyId,
      required this.basicFee,
      required this.pricePerCube});
  @override
  List<Object?> get props => [housingCompanyId, basicFee, pricePerCube];
}

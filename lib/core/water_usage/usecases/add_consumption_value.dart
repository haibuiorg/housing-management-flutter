import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

class AddConsumptionValue
    extends UseCase<WaterBill, AddConsumptionValueParams> {
  final WaterUsageRepository waterUsageRepository;

  AddConsumptionValue({required this.waterUsageRepository});
  @override
  Future<Result<WaterBill>> call(AddConsumptionValueParams params) {
    return waterUsageRepository.addConsumptionValue(
      housingCompanyId: params.housingCompanyId,
      waterConsumptionId: params.waterConsumptionId,
      consumption: params.consumption,
      buiding: params.buiding,
      apartmentId: params.apartmentId,
      houseCode: params.houseCode,
    );
  }
}

class AddConsumptionValueParams extends Equatable {
  final String housingCompanyId;
  final String waterConsumptionId;
  final double consumption;
  final String buiding;
  final String? apartmentId;
  final String? houseCode;

  const AddConsumptionValueParams({
    required this.housingCompanyId,
    required this.waterConsumptionId,
    required this.consumption,
    required this.buiding,
    this.apartmentId,
    this.houseCode,
  });
  @override
  List<Object?> get props => [
        housingCompanyId,
        waterConsumptionId,
        consumption,
        buiding,
        apartmentId,
        houseCode
      ];
}

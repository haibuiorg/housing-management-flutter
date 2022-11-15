import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

import 'get_water_bill.dart';

class GetWaterBillByYear extends UseCase<List<WaterBill>, GetWaterBillParams> {
  final WaterUsageRepository waterUsageRepository;

  GetWaterBillByYear({required this.waterUsageRepository});
  @override
  Future<Result<List<WaterBill>>> call(GetWaterBillParams params) {
    return waterUsageRepository.getWaterBillByYear(
      housingCompanyId: params.housingCompanyId,
      apartmentId: params.apartmentId,
      year: params.year,
    );
  }
}

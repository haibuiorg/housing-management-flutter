import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/water_bill.dart';
import '../repos/water_usage_repository.dart';

class GetWaterBill extends UseCase<List<WaterBill>, GetWaterBillParams> {
  final WaterUsageRepository waterUsageRepository;

  GetWaterBill({required this.waterUsageRepository});
  @override
  Future<Result<List<WaterBill>>> call(GetWaterBillParams params) {
    return waterUsageRepository.getWaterBill(
        housingCompanyId: params.housingCompanyId,
        apartmentId: params.apartmentId,
        year: params.year,
        period: params.period ?? 0);
  }
}

class GetWaterBillParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  final int year;
  final int? period;

  const GetWaterBillParams(
      {required this.housingCompanyId,
      required this.apartmentId,
      required this.year,
      this.period});
  @override
  List<Object?> get props => [housingCompanyId, apartmentId, year, period];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';

import '../repos/water_usage_repository.dart';

class GetWaterBillLink extends UseCase<String, GetWaterBillLinkParams> {
  final WaterUsageRepository waterUsageRepository;

  GetWaterBillLink({required this.waterUsageRepository});

  @override
  Future<Result<String>> call(GetWaterBillLinkParams params) {
    return waterUsageRepository.getWaterBillLink(
        waterBillId: params.waterBillId);
  }
}

class GetWaterBillLinkParams extends Equatable {
  final String waterBillId;

  const GetWaterBillLinkParams({required this.waterBillId});

  @override
  List<Object?> get props => [waterBillId];
}

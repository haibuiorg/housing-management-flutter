import 'package:priorli/core/water_usage/entities/consumption_value.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';

import '../../base/result.dart';
import '../entities/water_price.dart';

abstract class WaterUsageRepository {
  Future<Result<WaterPrice>> addNewWaterPrice({
    required String housingCompanyId,
    required double basicFee,
    required double pricePerCube,
  });
  Future<Result<WaterPrice>> deleteNewWaterPrice({
    required String housingCompanyId,
    required String id,
  });
  Future<Result<WaterPrice>> getActiveWaterPrice({
    required String housingCompanyId,
  });
  Future<Result<WaterConsumption>> startNewWaterConsumptionPeriod({
    required String housingCompanyId,
    required double totalReading,
  });
  Future<Result<WaterConsumption>> getWaterConsumption(
      {required String housingCompanyId,
      required int year,
      required int period});
  Future<Result<WaterConsumption>> getLatestWaterConsumption({
    required String housingCompanyId,
  });
  Future<Result<WaterConsumption>> getPreviousWaterConsumption({
    required String housingCompanyId,
  });
  Future<Result<ConsumptionValue>> addConsumptionValue({
    required String housingCompanyId,
    required String waterConsumptionId,
    required double consumption,
    required String buiding,
    String? apartmentId,
    String? houseCode,
  });
  Future<Result<List<WaterBill>>> getWaterBill({
    required String housingCompanyId,
    required String apartmentId,
    required int year,
    required int period,
  });
  Future<Result<List<WaterBill>>> getWaterBillByYear({
    required String housingCompanyId,
    required String apartmentId,
    required int year,
  });
}

import 'package:priorli/core/water_usage/models/consumption_value_model.dart';
import 'package:priorli/core/water_usage/models/water_bill_model.dart';
import 'package:priorli/core/water_usage/models/water_consumption_model.dart';
import 'package:priorli/core/water_usage/models/water_price_model.dart';

abstract class WaterUsageDataSource {
  Future<WaterPriceModel> addNewWaterPrice({
    required String housingCompanyId,
    required double basicFee,
    required double pricePerCube,
  });
  Future<WaterPriceModel> deleteNewWaterPrice({
    required String housingCompanyId,
    required String id,
  });
  Future<WaterPriceModel> getActiveWaterPrice({
    required String housingCompanyId,
  });
  Future<List<WaterPriceModel>> getWaterPriceHistory({
    required String housingCompanyId,
  });
  Future<WaterConsumptionModel> startNewWaterConsumptionPeriod({
    required String housingCompanyId,
    required double totalReading,
  });
  Future<WaterConsumptionModel> getWaterConsumption(
      {required String housingCompanyId,
      required int year,
      required int period});
  Future<WaterConsumptionModel> getLatestWaterConsumption({
    required String housingCompanyId,
  });
  Future<List<WaterConsumptionModel>> getYearlyWaterConsumption(
      {required String housingCompanyId, required int year});
  Future<WaterConsumptionModel> getPreviousWaterConsumption({
    required String housingCompanyId,
  });
  Future<WaterBillModel> addConsumptionValue({
    required String housingCompanyId,
    required String waterConsumptionId,
    required double consumption,
    required String buiding,
    String? apartmentId,
    String? houseCode,
  });
  Future<List<WaterBillModel>> getWaterBill({
    required String housingCompanyId,
    required String apartmentId,
    required int year,
    required int period,
  });
  Future<List<WaterBillModel>> getWaterBillByYear({
    required String housingCompanyId,
    required String apartmentId,
    required int year,
  });
  Future<String> getWaterBillLink({
    required String waterBillId,
  });
}

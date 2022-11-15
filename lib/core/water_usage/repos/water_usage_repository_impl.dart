import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/water_usage/data/water_usage_data_source.dart';
import 'package:priorli/core/water_usage/entities/consumption_value.dart';
import 'package:priorli/core/water_usage/entities/water_price.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/core/water_usage/repos/water_usage_repository.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';

class WaterUsageRepositoryImpl implements WaterUsageRepository {
  final WaterUsageDataSource waterUsageDataSource;

  WaterUsageRepositoryImpl({required this.waterUsageDataSource});

  @override
  Future<Result<ConsumptionValue>> addConsumptionValue(
      {required String housingCompanyId,
      required String waterConsumptionId,
      required double consumption,
      required String buiding,
      String? apartmentId,
      String? houseCode}) async {
    try {
      final consumptionValueModel =
          await waterUsageDataSource.addConsumptionValue(
              housingCompanyId: housingCompanyId,
              waterConsumptionId: waterConsumptionId,
              consumption: consumption,
              buiding: buiding,
              apartmentId: apartmentId,
              houseCode: houseCode);
      return ResultSuccess(
          ConsumptionValue.modelToEntity(consumptionValueModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<WaterPrice>> addNewWaterPrice(
      {required String housingCompanyId,
      required double basicFee,
      required double pricePerCube}) async {
    try {
      final waterPriceModel = await waterUsageDataSource.addNewWaterPrice(
          housingCompanyId: housingCompanyId,
          basicFee: basicFee,
          pricePerCube: pricePerCube);
      return ResultSuccess(WaterPrice.modelToEntity(waterPriceModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<WaterPrice>> deleteNewWaterPrice(
      {required String housingCompanyId, required String id}) async {
    try {
      final waterPriceModel = await waterUsageDataSource.deleteNewWaterPrice(
          housingCompanyId: housingCompanyId, id: id);
      return ResultSuccess(WaterPrice.modelToEntity(waterPriceModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<WaterPrice>> getActiveWaterPrice(
      {required String housingCompanyId}) async {
    try {
      final waterPriceModel = await waterUsageDataSource.getActiveWaterPrice(
        housingCompanyId: housingCompanyId,
      );
      return ResultSuccess(WaterPrice.modelToEntity(waterPriceModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<WaterConsumption>> getLatestWaterConsumption(
      {required String housingCompanyId}) async {
    try {
      final waterConsumptionModel =
          await waterUsageDataSource.getLatestWaterConsumption(
        housingCompanyId: housingCompanyId,
      );
      return ResultSuccess(
          WaterConsumption.modelToEntity(waterConsumptionModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<WaterConsumption>> getPreviousWaterConsumption(
      {required String housingCompanyId}) async {
    try {
      final waterConsumptionModel =
          await waterUsageDataSource.getPreviousWaterConsumption(
        housingCompanyId: housingCompanyId,
      );
      return ResultSuccess(
          WaterConsumption.modelToEntity(waterConsumptionModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<WaterBill>>> getWaterBill(
      {required String housingCompanyId,
      required String apartmentId,
      required int year,
      required int period}) async {
    try {
      final waterBillModels = await waterUsageDataSource.getWaterBill(
          housingCompanyId: housingCompanyId,
          apartmentId: apartmentId,
          year: year,
          period: period);
      return ResultSuccess(waterBillModels
          .map((waterConsumptionModel) =>
              WaterBill.modelToEntity(waterConsumptionModel))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<WaterConsumption>> getWaterConsumption(
      {required String housingCompanyId,
      required int year,
      required int period}) async {
    try {
      final waterConsumptionModel =
          await waterUsageDataSource.getWaterConsumption(
              housingCompanyId: housingCompanyId, year: year, period: period);
      return ResultSuccess(
          WaterConsumption.modelToEntity(waterConsumptionModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<WaterConsumption>> startNewWaterConsumptionPeriod(
      {required String housingCompanyId, required double totalReading}) async {
    try {
      final waterConsumptionModel =
          await waterUsageDataSource.startNewWaterConsumptionPeriod(
        housingCompanyId: housingCompanyId,
        totalReading: totalReading,
      );
      return ResultSuccess(
          WaterConsumption.modelToEntity(waterConsumptionModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<WaterBill>>> getWaterBillByYear(
      {required String housingCompanyId,
      required String apartmentId,
      required int year}) async {
    try {
      final waterBillModels = await waterUsageDataSource.getWaterBillByYear(
        housingCompanyId: housingCompanyId,
        apartmentId: apartmentId,
        year: year,
      );
      return ResultSuccess(waterBillModels
          .map((waterConsumptionModel) =>
              WaterBill.modelToEntity(waterConsumptionModel))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

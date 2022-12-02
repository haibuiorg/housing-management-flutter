import 'package:dio/dio.dart';
import 'package:priorli/core/water_usage/data/water_usage_data_source.dart';
import 'package:priorli/core/water_usage/models/water_price_model.dart';
import 'package:priorli/core/water_usage/models/water_consumption_model.dart';
import 'package:priorli/core/water_usage/models/water_bill_model.dart';

import '../../base/exceptions.dart';

class WaterUsageRemoteDataSource implements WaterUsageDataSource {
  final Dio client;
  final _path = '/water_consumption';
  final _pathPrice = '/water_price';
  final _pathBill = '/water_bill';
  final _pathBillLink = '/water_bill_link';

  WaterUsageRemoteDataSource({required this.client});

  @override
  Future<WaterBillModel> addConsumptionValue(
      {required String housingCompanyId,
      required String waterConsumptionId,
      required double consumption,
      required String buiding,
      String? apartmentId,
      String? houseCode}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "water_consumption_id": waterConsumptionId,
        "consumption": consumption,
        "building": buiding
      };
      if (apartmentId != null) {
        data["apartment_id"] = apartmentId;
      }
      if (houseCode != null) {
        data["house_code"] = houseCode;
      }
      final result = await client.post('$_path/new_value', data: data);
      return WaterBillModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<WaterPriceModel> addNewWaterPrice(
      {required String housingCompanyId,
      required double basicFee,
      required double pricePerCube}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "basic_fee": basicFee,
        "price_per_cube": pricePerCube,
      };
      final result = await client.post(_pathPrice, data: data);
      return WaterPriceModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<WaterPriceModel> deleteNewWaterPrice(
      {required String housingCompanyId, required String id}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "id": id,
      };
      final result = await client.delete(_pathPrice, data: data);
      return WaterPriceModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<WaterPriceModel> getActiveWaterPrice(
      {required String housingCompanyId}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
      };
      final result = await client.get(_pathPrice, queryParameters: data);
      return WaterPriceModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<WaterConsumptionModel> getLatestWaterConsumption(
      {required String housingCompanyId}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
      };
      final result = await client.get('$_path/latest', queryParameters: data);
      return WaterConsumptionModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<WaterConsumptionModel> getPreviousWaterConsumption(
      {required String housingCompanyId}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
      };
      final result = await client.get('$_path/previous', queryParameters: data);
      return WaterConsumptionModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<WaterBillModel>> getWaterBillByYear(
      {required String housingCompanyId,
      required String apartmentId,
      required int year}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "apartment_id": apartmentId
      };
      final result =
          await client.get('$_pathBill/$year', queryParameters: data);

      return (result.data as List<dynamic>)
          .map((json) => WaterBillModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<WaterBillModel>> getWaterBill(
      {required String housingCompanyId,
      required String apartmentId,
      required int year,
      required int period}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "year": year,
        "period": period,
        "apartment_id": apartmentId
      };
      final result = await client.get(_pathBill, queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => WaterBillModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<WaterConsumptionModel> getWaterConsumption(
      {required String housingCompanyId,
      required int year,
      required int period}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "year": year,
        "period": period
      };
      final result = await client.get(_path, queryParameters: data);
      return WaterConsumptionModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<WaterConsumptionModel> startNewWaterConsumptionPeriod(
      {required String housingCompanyId, required double totalReading}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "total_reading": totalReading
      };
      final result = await client.post(_path, data: data);
      return WaterConsumptionModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<WaterPriceModel>> getWaterPriceHistory(
      {required String housingCompanyId}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "is_history": true,
      };
      final result = await client.get(_pathPrice, queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => WaterPriceModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<WaterConsumptionModel>> getYearlyWaterConsumption(
      {required String housingCompanyId, required int year}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "year": year
      };
      final result = await client.get('$_path/yearly', queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => WaterConsumptionModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<String> getWaterBillLink({required String waterBillId}) async {
    final Map<String, dynamic> data = {
      "water_bill_id": waterBillId,
    };
    try {
      final result = await client.get(_pathBillLink, queryParameters: data);
      return (result.data as Map<String, dynamic>)['link'] ?? '';
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

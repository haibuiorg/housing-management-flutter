import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/entities/water_price.dart';
import 'package:priorli/core/water_usage/usecases/add_new_water_price.dart';
import 'package:priorli/core/water_usage/usecases/get_active_water_price.dart';
import 'package:priorli/core/water_usage/usecases/get_latest_water_consumption.dart';
import 'package:priorli/core/water_usage/usecases/get_water_consumption.dart';
import 'package:priorli/core/water_usage/usecases/get_water_price_history.dart';
import 'package:priorli/core/water_usage/usecases/start_new_water_consumptio_period.dart';

import 'water_consumption_management_state.dart';

class WaterConsumptionManagementCubit
    extends Cubit<WaterConsumptionManagementState> {
  final GetHousingCompany _getHousingCompany;
  final AddNewWaterPrice _addNewWaterPrice;
  final GetActiveWaterPrice _getActiveWaterPrice;
  final GetWaterPriceHistory _getWaterPriceHistory;
  final GetLatestWaterConsumption _getLatestWaterConsumption;
  final StartNewWaterConsumptionPeriod _startNewWaterConsumptionPeriod;
  WaterConsumptionManagementCubit(
      this._getHousingCompany,
      this._addNewWaterPrice,
      this._getActiveWaterPrice,
      this._startNewWaterConsumptionPeriod,
      this._getWaterPriceHistory,
      this._getLatestWaterConsumption)
      : super(const WaterConsumptionManagementState());

  Future<void> init(String housingCompanyId) async {
    final getHousingCompanyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    final getActiveWaterPriceResult = await _getActiveWaterPrice(
        GetActiveWaterPriceParams(housingCompanyId: housingCompanyId));
    final getWaterPriceHistoryResult = await _getWaterPriceHistory(
        GetWaterPriceHistoryParams(housingCompanyId: housingCompanyId));
    final getLatestWaterConsumptionResult = await _getLatestWaterConsumption(
        GetWaterConsumptionParams(housingCompanyId: housingCompanyId));
    WaterConsumptionManagementState pendingState = state.copyWith();
    if (getHousingCompanyResult is ResultSuccess<HousingCompany>) {
      pendingState = pendingState.copyWith(
          housingCompanyId: housingCompanyId,
          housingCompany: getHousingCompanyResult.data);
    }
    if (getActiveWaterPriceResult is ResultSuccess<WaterPrice>) {
      pendingState = pendingState.copyWith(
          activeWaterPrice: getActiveWaterPriceResult.data);
    }
    if (getWaterPriceHistoryResult is ResultSuccess<List<WaterPrice>>) {
      pendingState = pendingState.copyWith(
          waterPriceHistory: getWaterPriceHistoryResult.data);
    }
    if (getLatestWaterConsumptionResult is ResultSuccess<WaterConsumption>) {
      pendingState = pendingState.copyWith(
          latestWaterConsumption: getLatestWaterConsumptionResult.data);
    }
    emit(pendingState);
  }

  Future<void> addNewWaterPrice(String basicFee, String pricePerCube) async {
    final addNewWaterPriceResult = await _addNewWaterPrice(
        AddNewWaterPriceParams(
            basicFee: double.parse(basicFee),
            pricePerCube: double.parse(pricePerCube),
            housingCompanyId: state.housingCompanyId ?? ''));
    if (addNewWaterPriceResult is ResultSuccess<WaterPrice>) {
      final List<WaterPrice> newHistory =
          List.from(state.waterPriceHistory ?? []);
      newHistory.add(addNewWaterPriceResult.data);
      emit(state.copyWith(
          activeWaterPrice: addNewWaterPriceResult.data,
          waterPriceHistory: newHistory,
          finishManagement: true));
    }
  }

  Future<void> startNewWaterBillPeriod(double totalReading) async {
    final newWaterBillPeriodResult = await _startNewWaterConsumptionPeriod(
        StartNewWaterConsumptionPeriodParams(
            totalReading: totalReading,
            housingCompanyId: state.housingCompanyId ?? ''));
    if (newWaterBillPeriodResult is ResultSuccess<WaterConsumption>) {
      emit(state.copyWith(
          latestWaterConsumption: newWaterBillPeriodResult.data,
          finishManagement: true));
    }
  }
}

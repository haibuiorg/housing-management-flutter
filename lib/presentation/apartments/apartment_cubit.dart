import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartment.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/usecases/add_consumption_value.dart';
import 'package:priorli/core/water_usage/usecases/get_latest_water_consumption.dart';
import 'package:priorli/core/water_usage/usecases/get_water_bill.dart';
import 'package:priorli/core/water_usage/usecases/get_water_bill_by_year.dart';
import 'package:priorli/presentation/apartments/apartment_state.dart';

import '../../core/water_usage/usecases/get_water_consumption.dart';

class ApartmentCubit extends Cubit<ApartmentState> {
  final AddConsumptionValue _addConsumptionValue;
  final GetApartment _getApartment;
  final GetWaterBillByYear _getWaterBillByYear;
  final GetHousingCompany _getHousingCompany;
  final GetLatestWaterConsumption _getLatestWaterConsumption;

  ApartmentCubit(
      this._addConsumptionValue,
      this._getApartment,
      this._getWaterBillByYear,
      this._getLatestWaterConsumption,
      this._getHousingCompany)
      : super(const ApartmentState());

  Future<void> init(String housingCompanyId, String apartmentId) async {
    final apartmentResult = await _getApartment(GetApartmentSingleParams(
        housingCompanyId: housingCompanyId, apartmentId: apartmentId));
    final billByYearResult = await _getWaterBillByYear(GetWaterBillParams(
        year: DateTime.now().year,
        apartmentId: apartmentId,
        housingCompanyId: housingCompanyId));
    final getLatestWaterConsumptionResult = await _getLatestWaterConsumption(
        GetWaterConsumptionParams(housingCompanyId: housingCompanyId));
    final getHousingCompanyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    ApartmentState pendingState = state.copyWith();
    if (apartmentResult is ResultSuccess<Apartment>) {
      pendingState = pendingState.copyWith(apartment: apartmentResult.data);
    }
    if (billByYearResult is ResultSuccess<List<WaterBill>>) {
      pendingState =
          pendingState.copyWith(yearlyWaterBills: billByYearResult.data);
    }
    if (getLatestWaterConsumptionResult is ResultSuccess<WaterConsumption>) {
      pendingState = pendingState.copyWith(
          latestWaterConsumption: getLatestWaterConsumptionResult.data);
    }
    if (getHousingCompanyResult is ResultSuccess<HousingCompany>) {
      pendingState =
          pendingState.copyWith(housingCompany: getHousingCompanyResult.data);
    }
    emit(pendingState);
  }

  Future<void> addLatestConsumptionValue(double consumption) async {
    final addConsumptionResult = await _addConsumptionValue(
        AddConsumptionValueParams(
            housingCompanyId: state.apartment?.housingCompanyId ?? '',
            waterConsumptionId: state.latestWaterConsumption?.id ?? '',
            apartmentId: state.apartment?.id,
            consumption: consumption,
            buiding: state.apartment?.building ?? ''));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document_list.dart';
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

import '../../core/storage/entities/storage_item.dart';
import '../../core/water_usage/usecases/get_water_consumption.dart';

class ApartmentCubit extends Cubit<ApartmentState> {
  final AddConsumptionValue _addConsumptionValue;
  final GetApartment _getApartment;
  final GetWaterBillByYear _getWaterBillByYear;
  final GetHousingCompany _getHousingCompany;
  final GetApartmentDocument _getApartmentDocument;
  final GetApartmentDocumentList _getApartmentDocumentList;
  final GetLatestWaterConsumption _getLatestWaterConsumption;

  ApartmentCubit(
      this._addConsumptionValue,
      this._getApartment,
      this._getWaterBillByYear,
      this._getLatestWaterConsumption,
      this._getHousingCompany,
      this._getApartmentDocument,
      this._getApartmentDocumentList)
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
    final apartmentDocumentResult = await _getApartmentDocumentList(
        GetApartmentDocumentListParams(
            housingCompanyId: housingCompanyId, apartmentId: apartmentId));
    if (apartmentDocumentResult is ResultSuccess<List<StorageItem>>) {
      pendingState =
          (pendingState.copyWith(documentList: apartmentDocumentResult.data));
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
    emit(state.copyWith(
        newConsumptionAdded: addConsumptionResult is ResultSuccess<WaterBill>));
  }

  Future<StorageItem?> getDocument(String id) async {
    final getCompanyDocumentResult = await _getApartmentDocument(
        GetApartmentDocumentParams(
            housingCompanyId: state.housingCompany?.id ?? '',
            documentId: id,
            apartmentId: state.apartment?.id ?? ''));
    if (getCompanyDocumentResult is ResultSuccess<StorageItem>) {
      return getCompanyDocumentResult.data;
    }
    return null;
  }
}

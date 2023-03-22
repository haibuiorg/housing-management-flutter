import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document_list.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/fault_report/usecases/create_fault_report.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
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
  final CreateFaultReport _createFaultReport;

  ApartmentCubit(
      this._addConsumptionValue,
      this._getApartment,
      this._getWaterBillByYear,
      this._getLatestWaterConsumption,
      this._getHousingCompany,
      this._getApartmentDocument,
      this._getApartmentDocumentList,
      this._createFaultReport)
      : super(const ApartmentState());

  Future<void> init(String housingCompanyId, String apartmentId) async {
    getApartmentResult(housingCompanyId, apartmentId);
    getWaterBillByYear(housingCompanyId, apartmentId);
    getLatestWaterConsumption(housingCompanyId);
    getCompanyData(housingCompanyId);
    getApartmentDocument(housingCompanyId, apartmentId);
  }

  Future<void> getCompanyData(String housingCompanyId) async {
    final getHousingCompanyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    if (getHousingCompanyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(housingCompany: getHousingCompanyResult.data));
    }
  }

  Future<void> getApartmentDocument(
      String housingCompanyId, String apartmentId) async {
    final apartmentDocumentResult = await _getApartmentDocumentList(
        GetApartmentDocumentListParams(
            housingCompanyId: housingCompanyId, apartmentId: apartmentId));
    if (apartmentDocumentResult is ResultSuccess<List<StorageItem>>) {
      emit(state.copyWith(documentList: apartmentDocumentResult.data));
    }
  }

  Future<void> getLatestWaterConsumption(
    String housingCompanyId,
  ) async {
    final getLatestWaterConsumptionResult = await _getLatestWaterConsumption(
        GetWaterConsumptionParams(housingCompanyId: housingCompanyId));
    if (getLatestWaterConsumptionResult is ResultSuccess<WaterConsumption>) {
      emit(state.copyWith(
          latestWaterConsumption: getLatestWaterConsumptionResult.data));
    }
  }

  Future<void> getWaterBillByYear(
      String housingCompanyId, String apartmentId) async {
    final billByYearResult = await _getWaterBillByYear(GetWaterBillParams(
        year: DateTime.now().year,
        apartmentId: apartmentId,
        housingCompanyId: housingCompanyId));
    if (billByYearResult is ResultSuccess<List<WaterBill>>) {
      final waterBills = billByYearResult.data;
      waterBills.sort((a, b) => a.period.compareTo(b.period));
      emit(state.copyWith(yearlyWaterBills: waterBills));
    }
  }

  Future<void> getApartmentResult(
      String housingCompanyId, String apartmentId) async {
    final apartmentResult = await _getApartment(GetApartmentSingleParams(
        housingCompanyId: housingCompanyId, apartmentId: apartmentId));
    if (apartmentResult is ResultSuccess<Apartment>) {
      emit(state.copyWith(apartment: apartmentResult.data));
    }
  }

  Future<void> addLatestConsumptionValue(double consumption) async {
    final addConsumptionResult = await _addConsumptionValue(
        AddConsumptionValueParams(
            housingCompanyId: state.apartment?.housingCompanyId ?? '',
            waterConsumptionId: state.latestWaterConsumption?.id ?? '',
            apartmentId: state.apartment?.id,
            consumption: consumption,
            buiding: state.apartment?.building ?? ''));
    emit(state.copyWith());
  }

  Future<void> createNewFaultReport(
      {required String title,
      required String description,
      bool? sendEmail,
      List<String>? storageItems}) async {
    final faultReportResult = await _createFaultReport(CreateFaultReportParams(
        companyId: state.apartment?.housingCompanyId ?? '',
        title: title,
        apartmentId: state.apartment?.id ?? '',
        description: description,
        storageItems: storageItems,
        sendEmail: sendEmail));

    if (faultReportResult is ResultSuccess<Conversation>) {
      emit(state.copyWith(newFaultReport: faultReportResult.data));
    }
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

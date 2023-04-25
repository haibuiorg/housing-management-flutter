import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartment.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/fault_report/usecases/create_fault_report.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/usecases/get_company_conversation_lists.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/usecases/add_consumption_value.dart';
import 'package:priorli/core/water_usage/usecases/get_latest_water_consumption.dart';
import 'package:priorli/core/water_usage/usecases/get_water_bill.dart';
import 'package:priorli/core/water_usage/usecases/get_water_bill_by_year.dart';
import 'package:priorli/presentation/apartments/apartment_state.dart';

import '../../core/user/entities/user.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/user_utils.dart';
import '../../core/water_usage/usecases/get_water_consumption.dart';

class ApartmentCubit extends Cubit<ApartmentState> {
  final AddConsumptionValue _addConsumptionValue;
  final GetApartment _getApartment;
  final GetWaterBillByYear _getWaterBillByYear;
  final GetHousingCompany _getHousingCompany;
  final GetLatestWaterConsumption _getLatestWaterConsumption;
  final CreateFaultReport _createFaultReport;
  final GetCompanyConversationList _getCompanyConversationList;
  StreamSubscription? _conversationSubscription;

  ApartmentCubit(
      this._addConsumptionValue,
      this._getApartment,
      this._getWaterBillByYear,
      this._getCompanyConversationList,
      this._getLatestWaterConsumption,
      this._getHousingCompany,
      this._createFaultReport)
      : super(const ApartmentState());

  Future<void> init(
      String housingCompanyId, String apartmentId, User? user) async {
    emit(state.copyWith(isLoading: true));
    getWaterBillByYear(housingCompanyId, apartmentId);
    getLatestWaterConsumption(housingCompanyId);
    await getApartmentResult(housingCompanyId, apartmentId);
    await getCompanyData(housingCompanyId);
    if (user != null) {
      emit(state.copyWith(
          ownerView: isUserAdmin(user) ||
              state.apartment?.owners?.contains(user.userId) == true ||
              state.housingCompany?.isUserManager == true ||
              state.housingCompany?.isUserOwner == true));
    }
    emit(state.copyWith(isLoading: false));
    _conversationSubscription?.cancel();
    _conversationSubscription = _getCompanyConversationList(
            GetCompanyConversationParams(
                companyId: housingCompanyId, userId: user?.userId ?? ''))
        .listen(_messageListener);
  }

  _messageListener(List<Conversation> conversationList) {
    emit(state.copyWith(
      faultReportList: conversationList
          .where((element) =>
              element.type == messageTypeFaultReport &&
              element.apartmentId == state.apartment?.id)
          .toList(),
    ));
  }

  @override
  Future<void> close() {
    _conversationSubscription?.cancel();
    return super.close();
  }

  Future<void> getCompanyData(String housingCompanyId) async {
    final getHousingCompanyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    if (getHousingCompanyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(housingCompany: getHousingCompanyResult.data));
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
    emit(state.copyWith(isLoading: true));
    await _addConsumptionValue(AddConsumptionValueParams(
        housingCompanyId: state.apartment?.housingCompanyId ?? '',
        waterConsumptionId: state.latestWaterConsumption?.id ?? '',
        apartmentId: state.apartment?.id,
        consumption: consumption,
        buiding: state.apartment?.building ?? ''));
    emit(state.copyWith(isLoading: false));
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
}

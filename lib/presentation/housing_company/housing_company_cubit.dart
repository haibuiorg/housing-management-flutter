import 'package:bloc/bloc.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/core/announcement/usecases/get_announcement_list.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartments.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/usecases/get_yearly_water_consumption.dart';
import 'package:priorli/presentation/housing_company/housing_company_state.dart';

class HousingCompanyCubit extends Cubit<HousingCompanyState> {
  final GetApartments _getApartments;
  final GetHousingCompany _getHousingCompany;
  final GetYearlyWaterConsumption _getYearlyWaterConsumption;
  final GetAnnouncementList _getAnnouncementList;
  HousingCompanyCubit(this._getApartments, this._getHousingCompany,
      this._getYearlyWaterConsumption, this._getAnnouncementList)
      : super(const HousingCompanyState());

  Future<void> init(String housingCompanyId) async {
    final companyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    HousingCompanyState pendingState = state.copyWith();
    if (companyResult is ResultSuccess<HousingCompany>) {
      pendingState =
          (pendingState.copyWith(housingCompany: companyResult.data));
    }
    final apartResult = await _getApartments(
        GetApartmentParams(housingCompanyId: housingCompanyId));
    if (apartResult is ResultSuccess<List<Apartment>>) {
      pendingState = (pendingState.copyWith(apartmentList: apartResult.data));
    }
    final waterConsumptionResult = await _getYearlyWaterConsumption(
        GetYearlyWaterConsumptionParams(
            housingCompanyId: housingCompanyId, year: 2022));
    if (waterConsumptionResult is ResultSuccess<List<WaterConsumption>>) {
      pendingState = (pendingState.copyWith(
          yearlyWaterConsumption: waterConsumptionResult.data));
    }
    final announcementListResult = await _getAnnouncementList(
        GetAnnouncementListParams(
            housingCompanyId: housingCompanyId,
            lastAnnouncementTime: DateTime.now().millisecondsSinceEpoch,
            total: 2));
    if (announcementListResult is ResultSuccess<List<Announcement>>) {
      pendingState = (pendingState.copyWith(
          announcementList: announcementListResult.data));
    }
    emit(pendingState);
  }
}

import 'package:bloc/bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartments.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/presentation/housing_company/housing_company_state.dart';

class HousingCompanyCubit extends Cubit<HousingCompanyState> {
  final GetApartments _getApartments;
  final GetHousingCompany _getHousingCompany;
  HousingCompanyCubit(this._getApartments, this._getHousingCompany)
      : super(const HousingCompanyState());

  Future<void> init(String housingCompanyId) async {
    _getHousingCompanyData(housingCompanyId);
    _getAparmentData(housingCompanyId);
  }

  Future<void> _getHousingCompanyData(String housingCompanyId) async {
    final companyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    if (companyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(housingCompany: companyResult.data));
    }
  }

  Future<void> _getAparmentData(String housingCompanyId) async {
    final apartResult = await _getApartments(
        GetApartmentParams(housingCompanyId: housingCompanyId));
    if (apartResult is ResultSuccess<List<Apartment>>) {
      emit(state.copyWith(apartmentList: apartResult.data));
    }
  }
}

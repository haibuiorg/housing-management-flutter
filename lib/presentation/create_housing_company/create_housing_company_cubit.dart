import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/core/country/usecases/get_support_countries.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/create_housing_company.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_state.dart';

class CreateHousingCompanyCubit extends Cubit<CreateHousingCompanyState> {
  final CreateHousingCompany _createHousingCompany;
  final GetSupportCountries _getSupportCountries;

  CreateHousingCompanyCubit(
      this._createHousingCompany, this._getSupportCountries)
      : super(const CreateHousingCompanyState());

  Future<void> init() async {
    final countryResult = await _getSupportCountries(NoParams());
    if (countryResult is ResultSuccess<List<Country>>) {
      emit(state.copyWith(
          countryList: countryResult.data,
          selectedCountryCode: countryResult.data.isNotEmpty
              ? countryResult.data[0].countryCode
              : null));
    }
  }

  Future<void> createHousingCompany() async {
    if (state.companyName?.isEmpty == true || state.companyName == null) {
      return;
    }
    emit(state.copyWith(isLoading: true));
    final companyResult = await _createHousingCompany(
        CreateHousingCompanyParams(
            businessId: state.businessId,
            name: state.companyName!,
            countryCode: state.selectedCountryCode ?? 'fi'));
    emit(state.copyWith(isLoading: false));
    if (companyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(newCompanyId: companyResult.data.id));
    } else {
      emit(state.copyWith(
          errorText: (companyResult as ResultFailure).failure.toString()));
    }
  }

  onTypingName(String s) {
    emit(state.copyWith(companyName: s));
  }

  onTypingBusinessId(String? s) {
    emit(state.copyWith(businessId: s));
  }

  void selectCountry(String? countryCode) {
    emit(state.copyWith(selectedCountryCode: countryCode));
  }
}

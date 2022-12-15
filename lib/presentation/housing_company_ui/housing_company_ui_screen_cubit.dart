import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/housing/usecases/update_housing_company_info.dart';

import 'housing_company_ui_screen_state.dart';

class HousingCompanyUiScreenCubit extends Cubit<HousingCompanyUiScreenState> {
  final GetHousingCompany _getHousingCompany;
  final UpdateHousingCompanyInfo _updateHousingCompanyInfo;

  HousingCompanyUiScreenCubit(
    this._getHousingCompany,
    this._updateHousingCompanyInfo,
  ) : super(const HousingCompanyUiScreenState());

  Future<void> init(
    String companyId,
  ) async {
    final getCompanyInfoResult =
        await _getHousingCompany(GetHousingCompanyParams(
      housingCompanyId: companyId,
    ));
    if (getCompanyInfoResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(company: getCompanyInfoResult.data));
    }
  }

  Future<void> uploadNewLogo(String file) async {
    if (state.company != null) {
      final updateCompanyInfoResult = await _updateHousingCompanyInfo(
          UpdateHousingCompanyInfoParams(
              housingCompanyId: state.company?.id ?? '',
              logoStorageLink: file));

      if (updateCompanyInfoResult is ResultSuccess<HousingCompany>) {
        emit(state.copyWith(company: updateCompanyInfoResult.data));
      }
    }
  }

  Future<void> uploadNewCover(String file) async {
    if (state.company != null) {
      final updateCompanyInfoResult = await _updateHousingCompanyInfo(
          UpdateHousingCompanyInfoParams(
              housingCompanyId: state.company?.id ?? '',
              coverImageStorageLink: file));
      if (updateCompanyInfoResult is ResultSuccess<HousingCompany>) {
        emit(state.copyWith(company: updateCompanyInfoResult.data));
      }
    }
  }

  Future<void> updateCompanyColor(String seedColor) async {
    if (state.company != null) {
      final updateCompanyInfoResult = await _updateHousingCompanyInfo(
          UpdateHousingCompanyInfoParams(
              housingCompanyId: state.company?.id ?? '',
              ui: state.company?.ui?.copyWith(seedColor: seedColor)));
      if (updateCompanyInfoResult is ResultSuccess<HousingCompany>) {
        emit(state.copyWith(company: updateCompanyInfoResult.data));
      }
    }
  }
}

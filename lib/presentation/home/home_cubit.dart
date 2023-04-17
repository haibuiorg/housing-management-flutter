import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_companies.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHousingCompanies _getHousingCompanies;

  HomeCubit(
    this._getHousingCompanies,
  ) : super(HomeState.init());

  Future<void> getUserHousingCompanies() async {
    final housingCompanyResult = await _getHousingCompanies(NoParams());
    if (housingCompanyResult is ResultSuccess<List<HousingCompany>>) {
      emit(state.copyWith(housingCompanies: housingCompanyResult.data));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/create_housing_company.dart';
import 'package:priorli/presentation/create_housing_company/create_housing_company_state.dart';

class CreateHousingCompanyCubit extends Cubit<CreateHousingCompanyState> {
  final CreateHousingCompany _createHousingCompany;
  CreateHousingCompanyCubit(this._createHousingCompany)
      : super(const CreateHousingCompanyState());

  Future<void> createHousingCompany() async {
    if (state.companyName?.isEmpty == true || state.companyName == null) {
      return;
    }
    final companyResult = await _createHousingCompany(
        CreateHousingCompanyParams(name: state.companyName!));
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
}

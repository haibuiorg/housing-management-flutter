import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/add_apartments.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/presentation/add_apartment/add_apart_state.dart';

class AddApartmentCubit extends Cubit<AddApartmentState> {
  final AddApartments _addApartments;
  final GetHousingCompany _getHousingCompany;
  AddApartmentCubit(this._addApartments, this._getHousingCompany)
      : super(const AddApartmentState());

  Future<void> init(String housingCompanyId) async {
    final getHousingCompanyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    if (getHousingCompanyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(
          housingCompanyId: housingCompanyId,
          housingCompany: getHousingCompanyResult.data));
    }
  }

  updateBuilding(String building) {
    emit(state.copyWith(building: building));
  }

  updateAutomaticFillApartmentNumber(bool isAutomatic) {
    final houseList = !isAutomatic
        ? List.filled(state.houseCodes?.length ?? 0, '')
        : List.generate(state.houseCodes?.length ?? 0, ((index) {
            return (index + 1).toString();
          }));
    emit(state.copyWith(
        automaticHouseCodeInput: isAutomatic, houseCodes: houseList));
  }

  updateHouseCode(int numberOfHouse) {
    final houseList = state.automaticHouseCodeInput == false
        ? List.filled(numberOfHouse, '')
        : List.generate(numberOfHouse, ((index) {
            return (index + 1).toString();
          }));
    emit(state.copyWith(houseCodes: houseList));
  }

  updateHouseCodeDetail(int index, String value) {
    final List<String> houseList = List.from(state.houseCodes ?? []);
    houseList[index] = value;
    emit(state.copyWith(houseCodes: houseList));
  }

  Future<void> addApartments() async {
    if (state.houseCodes != null &&
        (state.houseCodes?.length ?? 0) > 1 &&
        state.houseCodes?.contains('') == true) {
      emit(state.copyWith(errorText: 'Empty house number'));
      return;
    }
    if (state.building == null || state.building?.isEmpty == true) {
      emit(state.copyWith(errorText: 'Empty Building name'));
      return;
    }
    final addApartmentResult = await _addApartments(AddApartmentParams(
        housingCompanyId: state.housingCompanyId ?? '',
        building: state.building ?? '',
        houseCodes: state.houseCodes));
    if (addApartmentResult is ResultSuccess<List<Apartment>>) {
      emit(state.copyWith(addedApartments: addApartmentResult.data));
    }
  }
}

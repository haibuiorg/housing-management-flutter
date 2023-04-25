import 'package:bloc/bloc.dart';
import 'package:priorli/core/apartment/usecases/get_apartments.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/add_company_manager.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company_managers.dart';
import 'package:priorli/core/housing/usecases/get_housing_company_users.dart';
import 'package:priorli/core/housing/usecases/remove_housing_company_manager.dart';
import 'package:priorli/core/housing/usecases/remove_tenant_from_company.dart';

import '../../core/apartment/entities/apartment.dart';
import '../../core/user/entities/user.dart';
import 'company_user_state.dart';

class CompanyUserCubit extends Cubit<CompanyUserState> {
  final GetHousingCompanyUsers _getHousingCompanyUsers;
  final GetHousingCompanyManagers _getHousingCompanyManagers;
  final AddCompanyManager _addCompanyManager;
  final GetHousingCompany _getHousingCompany;
  final GetApartments _getApartments;
  final RemoveHousingCompanyManager _removeHousingCompanyManager;
  final RemoveTenantFromCompany _removeTenantFromCompany;

  CompanyUserCubit(
      this._getHousingCompanyUsers,
      this._addCompanyManager,
      this._getHousingCompanyManagers,
      this._getHousingCompany,
      this._getApartments,
      this._removeHousingCompanyManager,
      this._removeTenantFromCompany)
      : super(const CompanyUserState());

  Future<void> init({
    required String companyId,
  }) async {
    final companyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: companyId));
    if (companyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(company: companyResult.data));
    } else {
      return;
    }
    if (!companyResult.data.isUserManager) {
      return;
    }
    final apartmentResult =
        await _getApartments(GetApartmentParams(housingCompanyId: companyId));
    if (apartmentResult is ResultSuccess<List<Apartment>>) {
      emit(state.copyWith(apartmentList: apartmentResult.data));
    }
    getCompanyManager(companyId);
    getCompanyUser(companyId);
  }

  Future<void> getCompanyUser(String companyId) async {
    final companyUserResult = await _getHousingCompanyUsers(
        GetHousingCompanyParams(housingCompanyId: companyId));
    if (companyUserResult is ResultSuccess<List<User>>) {
      final List<User> newList = [];
      for (var user in companyUserResult.data) {
        final hasApartment = state.apartmentList?.where((apartment) =>
            apartment.tenants?.any((resident) => resident == user.userId) ??
            false);
        final User processedUser = user.copyWith(
            apartments: hasApartment
                ?.map((e) => e.building + (e.houseCode ?? ''))
                .toList());
        newList.add(processedUser);
      }
      emit(state.copyWith(
        userList: newList,
      ));
    }
  }

  Future<void> getCompanyManager(String companyId) async {
    final managerResult = await _getHousingCompanyManagers(
        GetHousingCompanyParams(housingCompanyId: companyId));
    if (managerResult is ResultSuccess<List<User>>) {
      final List<User> newList = [];
      for (var user in managerResult.data) {
        final hasApartment = state.apartmentList?.where((apartment) =>
            apartment.tenants?.any((resident) => resident == user.userId) ??
            false);
        final User processedUser = user.copyWith(
            apartments: hasApartment
                ?.map((e) => e.building + (e.houseCode ?? ''))
                .toList());
        newList.add(processedUser);
      }
      emit(state.copyWith(managerList: newList));
    }
  }

  Future<void> addNewManager(
      {required String email,
      String? firstName,
      String? lastName,
      String? phone}) async {
    final addManagerResult = await _addCompanyManager(AddCompanyManagerParams(
        companyId: state.company?.id ?? '',
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone));
    if (addManagerResult is ResultSuccess<User>) {
      final List<User> currentList = List.from(state.managerList ?? []);
      currentList.insert(0, addManagerResult.data);
      emit(state.copyWith(managerList: currentList));
    }
  }
}

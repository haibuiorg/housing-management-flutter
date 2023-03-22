import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/country/usecases/get_country_legal_documents.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';
import 'package:priorli/core/user/usecases/update_user_info.dart';
import 'package:priorli/presentation/account/account_state.dart';

import '../../core/country/entities/legal_document.dart';

class AccountCubit extends Cubit<AccountState> {
  final GetUserInfo _getUserInfo;
  final UpdateUserInfo _updateUserInfo;
  final GetCountryLegalDocuments _getCountryLegalDocuments;
  AccountCubit(
      this._getUserInfo, this._updateUserInfo, this._getCountryLegalDocuments)
      : super(const AccountState());

  Future<void> init() async {
    final getUserInfo = await _getUserInfo(NoParams());
    if (getUserInfo is ResultSuccess<User>) {
      emit(state.copyWith(
          user: getUserInfo.data, pendingUser: getUserInfo.data));
    }
    final countryCode = state.user?.countryCode ?? 'fi';
    final getCountryLegalDocumentResult = await _getCountryLegalDocuments(
        GetCountryLegalDocumentDataParams(countryCode: countryCode));
    if (getCountryLegalDocumentResult is ResultSuccess<List<LegalDocument>>) {
      emit(state.copyWith(legalDocuments: getCountryLegalDocumentResult.data));
    }
  }

  updateFirstName(String value) {
    emit(state.copyWith(
        pendingUser: state.pendingUser?.copyWith(firstName: value)));
  }

  updateLastName(String value) {
    emit(state.copyWith(
        pendingUser: state.pendingUser?.copyWith(lastName: value)));
  }

  updatePhone(String value) {
    emit(
        state.copyWith(pendingUser: state.pendingUser?.copyWith(phone: value)));
  }

  Future<void> saveNewUserDetail() async {
    final saveNameUserResult = await _updateUserInfo(UpdateUserInfoParams(
      phone: state.pendingUser?.phone ?? state.user?.phone ?? '',
      lastName: state.pendingUser?.lastName ?? state.user?.lastName ?? '',
      firstName: state.pendingUser?.firstName ?? state.user?.firstName ?? '',
    ));
    if (saveNameUserResult is ResultSuccess<User>) {
      emit(state.copyWith(
          user: saveNameUserResult.data, pendingUser: saveNameUserResult.data));
    }
  }

  void updateUser(User? user) {
    emit(state.copyWith(user: user, pendingUser: user));
  }
}

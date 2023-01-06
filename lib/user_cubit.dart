import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';

import '../../core/user/usecases/update_user_info.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserInfo _getUserInfo;
  final UpdateUserInfo _updateUserInfo;
  UserCubit(this._getUserInfo, this._updateUserInfo)
      : super(const UserState()) {
    init();
  }

  Future<void> init() async {
    final getUserResult = await _getUserInfo(NoParams());
    if (getUserResult is ResultSuccess<User>) {
      emit(state.copyWith(user: getUserResult.data));
    }
  }

  Future<void> updateUserAvatar(List<String> tempUploadedFiles) async {
    final updateUserInfoResult = await _updateUserInfo(
        UpdateUserInfoParams(avatarStorageLocation: tempUploadedFiles[0]));
    if (updateUserInfoResult is ResultSuccess<User>) {
      emit(state.copyWith(user: updateUserInfoResult.data));
    }
  }

  Future<User?> saveNewUserDetail(
      {String? phone, String? lastName, String? firstName}) async {
    final saveNameUserResult = await _updateUserInfo(UpdateUserInfoParams(
      phone: phone ?? state.user?.phone ?? '',
      lastName: lastName ?? state.user?.lastName ?? '',
      firstName: firstName ?? state.user?.firstName ?? '',
    ));
    if (saveNameUserResult is ResultSuccess<User>) {
      emit(state.copyWith(
        user: saveNameUserResult.data,
      ));
    }
    return state.user;
  }
}

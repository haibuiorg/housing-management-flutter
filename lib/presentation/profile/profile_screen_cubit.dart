import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';

import '../../core/user/usecases/update_user_info.dart';
import 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  final GetUserInfo _getUserInfo;
  final UpdateUserInfo _updateUserInfo;
  ProfileScreenCubit(this._getUserInfo, this._updateUserInfo)
      : super(const ProfileScreenState());

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
}

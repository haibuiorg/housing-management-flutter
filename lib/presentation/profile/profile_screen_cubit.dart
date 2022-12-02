import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';

import 'profile_screen_state.dart';

class ProfileScreenCubit extends Cubit<ProfileScreenState> {
  final GetUserInfo _getUserInfo;
  ProfileScreenCubit(this._getUserInfo) : super(const ProfileScreenState());

  Future<void> init() async {
    final getUserResult = await _getUserInfo(NoParams());
    if (getUserResult is ResultSuccess<User>) {
      emit(state.copyWith(user: getUserResult.data));
    }
  }
}

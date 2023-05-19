import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';
import 'package:priorli/core/utils/user_utils.dart';

import 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final GetUserInfo _getUserInfo;

  MainCubit(this._getUserInfo) : super(const MainState());

  Future<bool> init(int selectedIndex) async {
    final result = await _getUserInfo(NoParams());
    if (result is ResultSuccess<User>) {
      emit(state.copyWith(
          user: result.data,
          selectedTabIndex: selectedIndex,
          isAdmin: isUserAdmin(result.data),
          isInitializing: false));
      return true;
    }
    return false;
  }

  void changeTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }
}

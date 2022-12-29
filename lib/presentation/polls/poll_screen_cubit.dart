import 'package:bloc/bloc.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/entities/poll_type.dart';
import 'package:priorli/core/poll/usecases/add_poll_option.dart';
import 'package:priorli/core/poll/usecases/create_poll.dart';
import 'package:priorli/core/poll/usecases/edit_poll.dart';
import 'package:priorli/core/poll/usecases/remove_poll_option.dart';
import 'package:priorli/core/poll/usecases/select_poll_option.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';
import 'package:priorli/presentation/polls/poll_screen_state.dart';

import '../../core/base/result.dart';
import '../../core/base/usecase.dart';
import '../../core/housing/entities/housing_company.dart';
import '../../core/poll/usecases/get_poll.dart';
import '../../core/user/entities/user.dart';

class PollScreenCubit extends Cubit<PollScreenState> {
  final GetPoll _getPoll;
  final EditPoll _editPoll;
  final CreatePoll _createPoll;
  final RemovePollOption _removePollOption;
  final AddPollOption _addPollOption;
  final SelectPollOption _selectPollOption;
  final GetUserInfo _getUserInfo;
  final GetHousingCompany _getHousingCompany;
  PollScreenCubit(
      this._getPoll,
      this._editPoll,
      this._removePollOption,
      this._addPollOption,
      this._selectPollOption,
      this._getUserInfo,
      this._getHousingCompany,
      this._createPoll)
      : super(const PollScreenState());

  Future<void> init({String? pollId, required String companyId}) async {
    emit(state.copyWith(companyId: companyId));
    getUserData();
    getCompanyData(companyId);
    if (pollId == null) {
      emit(state.copyWith(isInitializing: false));
      return;
    }
    getPollData(pollId);
  }

  Future<void> getPollData(String pollId) async {
    final getEventResult = await _getPoll(GetPollParams(id: pollId));
    if (getEventResult is ResultSuccess<Poll>) {
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(
        poll: getEventResult.data,
        isInitializing: false,
      ));
    }
  }

  Future<void> getUserData() async {
    final getUserResult = await _getUserInfo(NoParams());
    if (getUserResult is ResultSuccess<User>) {
      emit(state.copyWith(userId: getUserResult.data.userId));
    }
  }

  Future<void> getCompanyData(String companyId) async {
    final getCompanyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: companyId));
    if (getCompanyResult is ResultSuccess<HousingCompany>) {
      emit(
          state.copyWith(company: getCompanyResult.data, companyId: companyId));
    }
  }

  Future<void> createPoll({
    required String name,
    required String description,
    int? endedOn,
    required bool expandable,
    required PollType type,
    required List<String> invitees,
    required bool annonymous,
    required bool multiple,
    required List<String> votingOptions,
  }) async {
    final createPollResult = await _createPoll(CreatePollParams(
        name: name,
        description: description,
        expandable: expandable,
        annonymous: annonymous,
        endedOn: endedOn,
        type: type,
        multiple: multiple,
        companyId: state.companyId ?? '',
        invitees: invitees,
        votingOptions: votingOptions));
    if (createPollResult is ResultSuccess<Poll>) {
      emit(state.copyWith(poll: createPollResult.data));
    }
  }

  Future<void> editPoll({
    String? name,
    String? description,
    int? endedOn,
    bool? expandable,
    bool? multiple,
    required String pollId,
  }) async {
    final editPollResult = await _editPoll(EditPollParams(
        name: name,
        description: description,
        pollId: pollId,
        endedOn: endedOn,
        expandable: expandable,
        multiple: multiple));
    if (editPollResult is ResultSuccess<Poll>) {
      emit(state.copyWith(poll: editPollResult.data));
    }
  }

  Future<void> deletePoll({
    required String pollId,
  }) async {
    final editPollResult =
        await _editPoll(EditPollParams(deleted: true, pollId: pollId));
    if (editPollResult is ResultSuccess<Poll>) {
      emit(state.copyWith(poll: editPollResult.data));
    }
  }

  Future<void> addPollOption(
      {required String pollId, required List<String> votingOptions}) async {
    final addPollOptionResult = await _addPollOption(
        AddPollOptionParams(votingOptions: votingOptions, pollId: pollId));
    if (addPollOptionResult is ResultSuccess<Poll>) {
      emit(state.copyWith(poll: addPollOptionResult.data));
    }
  }

  Future<void> removePollOption(
      {required String pollId, required String votingOptionId}) async {
    final removePollOptionResult = await _removePollOption(
        RemovePollOptionParams(votingOptionId: votingOptionId, pollId: pollId));
    if (removePollOptionResult is ResultSuccess<Poll>) {
      emit(state.copyWith(poll: removePollOptionResult.data));
    }
  }

  Future<void> selectPollOption(
      {required String pollId, required String votingOptionId}) async {
    final selectPollOptionResult = await _selectPollOption(
        SelectPollOptionParams(votingOptionId: votingOptionId, pollId: pollId));
    if (selectPollOptionResult is ResultSuccess<Poll>) {
      emit(state.copyWith(poll: selectPollOptionResult.data));
    }
  }
}

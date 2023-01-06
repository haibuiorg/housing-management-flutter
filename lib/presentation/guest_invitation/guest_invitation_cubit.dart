import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/event/entities/event.dart';
import 'package:priorli/core/event/usecases/get_event.dart';
import 'package:priorli/core/event/usecases/invite_to_event.dart';
import 'package:priorli/core/event/usecases/remove_user_from_event.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company_users.dart';
import 'package:priorli/core/poll/entities/poll.dart';
import 'package:priorli/core/poll/usecases/get_poll.dart';
import 'package:priorli/core/poll/usecases/invite_users_to_poll.dart';
import 'package:priorli/presentation/guest_invitation/guest_invitation_state.dart';

import '../../core/user/entities/user.dart';

class GuestInvitationCubit extends Cubit<GuestInvitationState> {
  final GetHousingCompanyUsers _getHousingCompanyUsers;
  final InviteToEvent _inviteToEvent;
  final RemoveUserFromEvent _removeUserFromEvent;
  final GetEvent _getEvent;
  final GetPoll _getPoll;
  final InviteUsersToPoll _inviteUsersToPoll;
  GuestInvitationCubit(
      this._getHousingCompanyUsers,
      this._inviteToEvent,
      this._removeUserFromEvent,
      this._inviteUsersToPoll,
      this._getEvent,
      this._getPoll)
      : super(const GuestInvitationState());

  Future<void> init(
      {required String companyId,
      List<String>? selectedUsers,
      String? eventId,
      String? pollId}) async {
    emit(state.copyWith(
        selectedUsers: selectedUsers, eventId: eventId, pollId: pollId));
    getCompanyUser(companyId);
    if (eventId != null) {
      getEventData(eventId);
    }
    if (pollId != null) {
      getPollData(pollId);
    }
  }

  Future<void> getCompanyUser(String companyId) async {
    final companyUserResult = await _getHousingCompanyUsers(
        GetHousingCompanyParams(housingCompanyId: companyId));
    if (companyUserResult is ResultSuccess<List<User>>) {
      emit(state.copyWith(
        userList: companyUserResult.data,
      ));
    }
  }

  Future<void> getEventData(String eventId) async {
    final eventResult = await _getEvent(GetEventParams(id: eventId));
    if (eventResult is ResultSuccess<Event>) {
      emit(state.copyWith(
        eventId: eventId,
        initialUsers: eventResult.data.invitees,
        selectedUsers: eventResult.data.accepted,
      ));
    }
  }

  Future<void> getPollData(String pollId) async {
    final pollResult = await _getPoll(GetPollParams(id: pollId));
    if (pollResult is ResultSuccess<Poll>) {
      emit(state.copyWith(
        pollId: pollId,
        initialUsers: pollResult.data.invitees,
      ));
    }
  }

  addUser(int index) {
    final List<String> newList = List.from(state.selectedUsers ?? []);
    newList.add(state.userList?[index].userId ?? '');
    emit(state.copyWith(selectedUsers: newList));
  }

  removeUser(int index) {
    final List<String> newList = List.from(state.selectedUsers ?? []);
    newList.remove(state.userList?[index].userId ?? '');
    emit(state.copyWith(selectedUsers: newList));
  }

  Future<void> removeInvited(int index) async {
    final userId = state.userList?[index].userId ?? '';
    if (state.eventId?.isNotEmpty == true) {
      final inviteEventResult = await _removeUserFromEvent(
          RemoveUserFromEventParams(
              eventId: state.eventId!, removedUsers: [userId]));
      if (inviteEventResult is ResultSuccess<Event>) {
        final List<String> newList = List.from(state.initialUsers ?? []);
        newList.remove(state.userList?[index].userId ?? '');
        emit(state.copyWith(initialUsers: newList));
      }
    }
  }

  Future<void> addAdditionInvitees(int index) async {
    final userId = state.userList?[index].userId ?? '';
    if (state.eventId?.isNotEmpty == true) {
      final inviteEventResult = await _inviteToEvent(InviteToEventParams(
          eventId: state.eventId!, additionInvitees: [userId]));
      if (inviteEventResult is ResultSuccess<Event>) {
        final List<String> newList = List.from(state.initialUsers ?? []);
        newList.add(state.userList?[index].userId ?? '');
        emit(state.copyWith(initialUsers: newList));
      }
    } else if (state.pollId?.isNotEmpty == true) {
      final invitePollResult = await _inviteUsersToPoll(InviteUsersToPollParams(
          pollId: state.pollId!, additionInvitees: [userId]));
      if (invitePollResult is ResultSuccess<Event>) {
        final List<String> newList = List.from(state.initialUsers ?? []);
        newList.add(state.userList?[index].userId ?? '');
        emit(state.copyWith(initialUsers: newList));
      }
    }
  }
}

import 'package:equatable/equatable.dart';

import '../../core/user/entities/user.dart';

class GuestInvitationState extends Equatable {
  final List<User>? userList;
  final List<String>? selectedUsers;
  final List<String>? initialUsers;
  final String? pollId;
  final String? eventId;

  const GuestInvitationState(
      {this.userList,
      this.selectedUsers,
      this.initialUsers,
      this.eventId,
      this.pollId});

  GuestInvitationState copyWith(
          {List<User>? userList,
          String? eventId,
          String? pollId,
          List<String>? selectedUsers,
          List<String>? initialUsers}) =>
      GuestInvitationState(
          selectedUsers: selectedUsers ?? this.selectedUsers,
          initialUsers: initialUsers ?? this.initialUsers,
          pollId: pollId ?? this.pollId,
          eventId: eventId ?? this.eventId,
          userList: userList ?? this.userList);
  @override
  List<Object?> get props =>
      [userList, selectedUsers, initialUsers, pollId, eventId];
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/guest_invitation/guest_invitation_state.dart';
import 'package:priorli/presentation/shared/app_user_circle_avatar.dart';
import 'package:priorli/service_locator.dart';

import '../../core/user/entities/user.dart';
import 'guest_invitation_cubit.dart';

class GuestInvitation extends StatefulWidget {
  const GuestInvitation({
    super.key,
    required this.companyId,
    required this.onUserSelected,
    this.initialSelectedUser,
    this.selectAll = false,
    this.eventId,
    this.pollId,
  });
  final String companyId;
  final List<String>? initialSelectedUser;
  final String? eventId;
  final String? pollId;
  final bool selectAll;
  final Function({required List<User> userList}) onUserSelected;
  @override
  State<GuestInvitation> createState() => _GuestInvitationState();
}

class _GuestInvitationState extends State<GuestInvitation> {
  late final GuestInvitationCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  _getInitialData() async {
    await _cubit.init(
      companyId: widget.companyId,
      selectedUsers: widget.initialSelectedUser,
      pollId: widget.pollId,
      eventId: widget.eventId,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GuestInvitationCubit>(
      create: (_) => _cubit,
      child: BlocBuilder<GuestInvitationCubit, GuestInvitationState>(
          builder: (context, state) {
        bool isEditMode = state.pollId?.isNotEmpty == true ||
            state.eventId?.isNotEmpty == true;
        return Scaffold(
          appBar: AppBar(
            actions: isEditMode
                ? null
                : [
                    TextButton(
                        onPressed: () {
                          widget.onUserSelected(
                              userList: state.userList
                                      ?.where((e) => (state.selectedUsers ?? [])
                                          .contains(e.userId))
                                      .toList() ??
                                  []);
                        },
                        child: const Text('Save'))
                  ],
          ),
          body: ListView.builder(
              itemCount: state.userList?.length ?? 0,
              itemBuilder: (context, index) => isEditMode
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
                          child: AppUserCircleAvatar(
                            user: state.userList?[index],
                          ),
                        ),
                        Expanded(
                          child: Text(
                              '${state.userList?[index].firstName ?? ''} ${state.userList?[index].lastName ?? ''}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: (state.selectedUsers ?? [])
                                  .contains(state.userList?[index].userId)
                              ? const Text('Accepted')
                              : (state.initialUsers ?? [])
                                      .contains(state.userList?[index].userId)
                                  ? Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text('Invited'),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              _cubit.removeInvited(index);
                                            },
                                            icon:
                                                const Icon(Icons.close_rounded))
                                      ],
                                    )
                                  : OutlinedButton(
                                      child: const Text('Send invitation'),
                                      onPressed: () {
                                        _cubit.addAdditionInvitees(index);
                                      },
                                    ),
                        ),
                      ],
                    )
                  : CheckboxListTile(
                      secondary: AppUserCircleAvatar(
                        user: state.userList?[index],
                      ),
                      title: Text(
                          '${state.userList?[index].firstName ?? ''} ${state.userList?[index].lastName ?? ''}'),
                      onChanged: (value) {
                        if (value == true) {
                          _cubit.addUser(index);
                        } else {
                          _cubit.removeUser(index);
                        }
                      },
                      value: (state.selectedUsers ?? [])
                          .contains(state.userList?[index].userId),
                    )),
        );
      }),
    );
  }
}

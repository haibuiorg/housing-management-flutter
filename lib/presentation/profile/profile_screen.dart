import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/notification_center/notification_center_screen.dart';
import 'package:priorli/presentation/profile/profile_screen_state.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import 'package:priorli/service_locator.dart';

import '../account/account_screen.dart';
import '../help/help_screen.dart';
import '../shared/app_preferences.dart';
import 'profile_screen_cubit.dart';

const profilePath = '/profile';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileScreenCubit>(
      create: (_) => serviceLocator<ProfileScreenCubit>()..init(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 8.0, vertical: MediaQuery.of(context).padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppPreferences(),
              const Spacer(),
              BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
                  builder: (context, state) {
                return CircleAvatar(
                  radius: 56,
                  child: state.user?.avatarUrl?.isNotEmpty == true
                      ? Image.network(state.user?.avatarUrl ?? '')
                      : Text(
                          (state.user?.firstName.characters.first
                                      .toUpperCase() ??
                                  '') +
                              (state.user?.lastName.characters.first
                                      .toUpperCase() ??
                                  ''),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                );
              }),
              const Spacer(),
              SettingButton(
                onPressed: () {
                  GoRouter.of(context).push(accountPath);
                },
                label: const Text('Account'),
              ),
              SettingButton(
                onPressed: () {
                  GoRouter.of(context).push(
                      '${GoRouter.of(context).location}/$notificationCenterPath');
                },
                label: const Text('Notification Center'),
              ),
              SettingButton(
                onPressed: () {
                  GoRouter.of(context).push(helpPath);
                },
                label: const Text('Help'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

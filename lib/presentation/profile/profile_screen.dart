import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/notification_center/notification_center_screen.dart';
import 'package:priorli/presentation/shared/app_user_circle_avatar.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import 'package:priorli/user_cubit.dart';
import 'package:priorli/user_state.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../account/account_screen.dart';
import '../help/help_screen.dart';
import '../shared/app_preferences.dart';

const profilePath = '/settings';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 8.0, vertical: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            ResponsiveVisibility(
              visible: false,
              visibleWhen: const [
                Condition.smallerThan(name: TABLET, landscapeValue: true),
              ],
              child:
                  BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                return InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      GoRouter.of(context).push(accountPath);
                    },
                    child: AppUserCircleAvatar(
                      radius: 56,
                      user: state.user,
                    ));
              }),
            ),
            const Spacer(),
            const AppPreferences(),
            SettingButton(
              onPressed: () {
                GoRouter.of(context).push(notificationCenterPath);
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
    );
  }
}

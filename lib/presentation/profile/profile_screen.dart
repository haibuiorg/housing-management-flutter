import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/file_selector/file_selector.dart';
import 'package:priorli/presentation/notification_center/notification_center_screen.dart';
import 'package:priorli/presentation/shared/app_user_circle_avatar.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import 'package:priorli/user_cubit.dart';
import 'package:priorli/user_state.dart';

import '../account/account_screen.dart';
import '../help/help_screen.dart';
import '../shared/app_preferences.dart';

const profilePath = '/profile';

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
            const AppPreferences(),
            const Spacer(),
            BlocBuilder<UserCubit, UserState>(builder: (context, state) {
              return InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) => FileSelector(
                              isSingleFile: true,
                              isImageOnly: true,
                              previewUrl: state.user?.avatarUrl,
                              onCompleteUploaded: (tempUploadedFiles) {
                                BlocProvider.of<UserCubit>(context)
                                    .updateUserAvatar(tempUploadedFiles)
                                    .then((value) =>
                                        Navigator.pop(context, true));
                              },
                            ));
                  },
                  child: AppUserCircleAvatar(
                    radius: 56,
                    user: state.user,
                  ));
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

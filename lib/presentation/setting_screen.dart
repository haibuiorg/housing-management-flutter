import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../setting_cubit.dart';
import '../setting_state.dart';
import '../auth_cubit.dart';

const settingPath = '/settings';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            child: const Text('Log out'),
            onPressed: () {
              BlocProvider.of<AuthCubit>(context).logOut();
            },
          ),
          BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
            return Switch.adaptive(
                value: state.brightness == Brightness.dark,
                onChanged: (onChanged) {
                  BlocProvider.of<SettingCubit>(context).switchTheme(onChanged);
                });
          })
        ],
      ),
    );
  }
}

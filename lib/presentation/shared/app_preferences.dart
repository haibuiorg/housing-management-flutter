import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import '../../setting_cubit.dart';
import '../../setting_state.dart';

class AppPreferences extends StatelessWidget {
  const AppPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      final languageList = state.appSupportLanguageCode;
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (languageList?.isNotEmpty == true)
            SettingButton(
              label: const Text('Language'),
              icon: DropdownButton<String>(
                enableFeedback: true,
                dropdownColor: Theme.of(context).colorScheme.primaryContainer,
                value: state.languageCode ?? languageList!.first,
                elevation: 16,
                borderRadius: BorderRadius.circular(8),
                underline: Container(
                  height: 0,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onChanged: (String? value) {
                  BlocProvider.of<SettingCubit>(context).switchLanguage(value);
                },
                items:
                    languageList!.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
                  );
                }).toList(),
              ),
            ),
          SettingButton(
            label: const Text('Dark mode'),
            icon: Switch(
                value: state.brightness == Brightness.dark,
                onChanged: (onChanged) {
                  BlocProvider.of<SettingCubit>(context).switchTheme(onChanged);
                }),
          )
        ],
      );
    });
  }
}

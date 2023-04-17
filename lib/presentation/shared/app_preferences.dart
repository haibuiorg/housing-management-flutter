import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import '../../setting_cubit.dart';
import '../../setting_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppPreferences extends StatelessWidget {
  const AppPreferences({super.key, this.mini = false});
  final bool mini;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      final languageList = state.appSupportLanguageCode;
      return mini
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (languageList?.isNotEmpty == true) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(AppLocalizations.of(context).language),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          enableFeedback: true,
                          dropdownColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          value: state.languageCode ?? languageList!.first,
                          elevation: 16,
                          borderRadius: BorderRadius.circular(8),
                          underline: Container(
                            height: 0,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          onChanged: (String? value) {
                            BlocProvider.of<SettingCubit>(context)
                                .switchLanguage(value);
                          },
                          items: languageList!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.toUpperCase()),
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(AppLocalizations.of(context).dark_theme),
                      const SizedBox(width: 8),
                      Switch(
                          value: state.brightness == Brightness.dark,
                          onChanged: (onChanged) {
                            BlocProvider.of<SettingCubit>(context)
                                .switchTheme(onChanged);
                          }),
                    ],
                  )
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (languageList?.isNotEmpty == true)
                  SettingButton(
                    label: Text(AppLocalizations.of(context).language),
                    icon: DropdownButton<String>(
                      enableFeedback: true,
                      dropdownColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      value: state.languageCode ?? languageList!.first,
                      elevation: 16,
                      borderRadius: BorderRadius.circular(8),
                      underline: Container(
                        height: 0,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      onChanged: (String? value) {
                        BlocProvider.of<SettingCubit>(context)
                            .switchLanguage(value);
                      },
                      items: languageList!
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.toUpperCase()),
                        );
                      }).toList(),
                    ),
                  ),
                SettingButton(
                  label: Text(AppLocalizations.of(context).dark_theme),
                  icon: Switch(
                      value: state.brightness == Brightness.dark,
                      onChanged: (onChanged) {
                        BlocProvider.of<SettingCubit>(context)
                            .switchTheme(onChanged);
                      }),
                )
              ],
            );
    });
  }
}

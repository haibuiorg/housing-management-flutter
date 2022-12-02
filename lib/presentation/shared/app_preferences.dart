import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../setting_cubit.dart';
import '../../setting_state.dart';

class AppPreferences extends StatelessWidget {
  const AppPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      final languageList = state.appSupportLanguageCode;
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(
            flex: 5,
          ),
          languageList?.isNotEmpty == true
              ? Column(
                  children: [
                    const Text('Language'),
                    DropdownButton<String>(
                      enableFeedback: true,
                      dropdownColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      value: state.languageCode ?? languageList!.first,
                      // ignore: prefer_const_constructors
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          Icons.language,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
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
              : const SizedBox.shrink(),
          const Spacer(),
          Column(
            children: [
              const Text('Dark mode'),
              Switch(
                  value: state.brightness == Brightness.dark,
                  onChanged: (onChanged) {
                    BlocProvider.of<SettingCubit>(context)
                        .switchTheme(onChanged);
                  }),
            ],
          ),
        ],
      );
    });
  }
}

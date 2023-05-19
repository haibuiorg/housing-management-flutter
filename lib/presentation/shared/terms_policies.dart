import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:priorli/setting_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndPolicies extends StatelessWidget {
  const TermsAndPolicies(
      {super.key, required this.onCheckChanged, required this.accepted});
  final Function(bool) onCheckChanged;
  final bool accepted;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      return Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onTap: () => launchUrl(Uri.parse(state.legalDocuments
                          ?.where((element) => element.type == 'terms')
                          .first
                          .webUrl ??
                      'https://www.priorli.com/terms-of-use')),
                  child: Text(AppLocalizations.of(context)!.terms_of_use,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleSmall
                          ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              decoration: TextDecoration.underline)),
                ),
              )),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InkWell(
                  onTap: () => launchUrl(Uri.parse(state.legalDocuments
                          ?.where((element) => element.type == 'policies')
                          .first
                          .webUrl ??
                      'https://www.priorli.com/privacy-policies')),
                  child: Text(AppLocalizations.of(context)!.privacy_policies,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleSmall
                          ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              decoration: TextDecoration.underline)),
                ),
              )),
          CheckboxListTile(
              value: (accepted),
              onChanged: (onChanged) {
                onCheckChanged(onChanged!);
              },
              title: Text(AppLocalizations.of(context)!.accept_terms_policy)),
        ],
      );
    });
  }
}

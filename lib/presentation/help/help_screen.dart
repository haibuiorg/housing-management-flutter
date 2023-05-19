import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/help/help_cubit.dart';
import 'package:priorli/presentation/help/help_state.dart';
import 'package:priorli/presentation/message/message_screen.dart';
import 'package:priorli/presentation/shared/app_webview.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const helpPath = '/faq';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late final HelpCubit _cubit;
  late TextEditingController _textEditingController;

  _launchPhone(String phoneNumber) {
    launchUrlString("tel://$phoneNumber");
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _cubit = serviceLocator<HelpCubit>();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.init();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: BlocConsumer<HelpCubit, HelpState>(listener: (context, state) {
        if (state.createdConversation != null) {
          Navigator.pop(context, true);
          GoRouter.of(context).push(
              '$messagePath/${state.createdConversation?.type}/${state.createdConversation?.channelId}/${state.createdConversation?.id}');
        }
      }, builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.help),
          ),
          body: Column(
            children: [
              const Expanded(child: AppWebView()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: ShapeDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _launchPhone(state
                                  .supportCountries?.first.supportPhoneNumber ??
                              '');
                        },
                        icon: Icon(
                          Icons.call_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      decoration: ShapeDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return BlocProvider.value(
                                    value: _cubit,
                                    child: const SupportConversationDialog());
                              });
                        },
                        icon: Icon(
                          Icons.email_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SupportConversationDialog extends StatefulWidget {
  const SupportConversationDialog({super.key});

  @override
  State<SupportConversationDialog> createState() =>
      _SupportConversationDialogState();
}

class _SupportConversationDialogState extends State<SupportConversationDialog> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpCubit, HelpState>(builder: (context, state) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFormField(
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.sentences,
              hintText: AppLocalizations.of(context)!.support_subject,
              textEditingController: _textEditingController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.country),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: List.generate(state.supportCountries?.length ?? 0,
                      (index) {
                    return ChoiceChip(
                      labelPadding: const EdgeInsets.all(2.0),
                      label: Flag.fromString(
                        state.supportCountries?[index].countryCode ?? 'fi',
                        height: 24,
                        width: 24,
                        flagSize: FlagSize.size_1x1,
                        borderRadius: 4,
                      ),
                      selected: state.supportCountries?[index].countryCode
                              .toLowerCase() ==
                          state.selectedCountryCode?.toLowerCase(),
                      onSelected: (value) {
                        BlocProvider.of<HelpCubit>(context).chooseNewCountry(
                            state.supportCountries?[index].countryCode ?? '');
                      },
                      elevation: 1,
                    );
                  }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.language),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: List.generate(
                      state.supportCountries
                              ?.where((element) =>
                                  element.countryCode ==
                                  state.selectedCountryCode)
                              .first
                              .supportLanguages
                              .length ??
                          0, (index) {
                    return ChoiceChip(
                      labelPadding: const EdgeInsets.all(2.0),
                      label: Text(state.supportCountries
                              ?.where((element) =>
                                  element.countryCode ==
                                  state.selectedCountryCode)
                              .first
                              .supportLanguages[index]
                              .capitalize() ??
                          ''),
                      selected: state.supportCountries
                              ?.where((element) =>
                                  element.countryCode ==
                                  state.selectedCountryCode)
                              .first
                              .supportLanguages[index]
                              .toLowerCase() ==
                          state.selectedLanguageCode?.toLowerCase(),
                      onSelected: (value) {
                        BlocProvider.of<HelpCubit>(context).chooseNewLanguage(
                            state.supportCountries
                                    ?.where((element) =>
                                        element.countryCode ==
                                        state.selectedCountryCode)
                                    .first
                                    .supportLanguages[index] ??
                                '');
                      },
                      elevation: 1,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              BlocProvider.of<HelpCubit>(context)
                  .startSupportConversation(_textEditingController.text)
                  .then((value) => Navigator.pop(context));
            },
            child: Text(AppLocalizations.of(context)!.start),
          )
        ],
      );
    });
  }
}

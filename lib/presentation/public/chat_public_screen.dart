import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/auth_cubit.dart';
import 'package:priorli/auth_state.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/home/home_screen.dart';
import 'package:priorli/presentation/public/chat_public_cubit.dart';
import 'package:priorli/presentation/public/chat_public_state.dart';
import 'package:priorli/presentation/shared/app_preferences.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:priorli/service_locator.dart';
import 'package:priorli/setting_cubit.dart';
import '../message/message_screen.dart';
import '../shared/terms_policies.dart';

const publicChatScreenPath = '/housing-gpt';

class ChatPublicScreen extends StatefulWidget {
  const ChatPublicScreen({super.key});

  @override
  State<ChatPublicScreen> createState() => _ChatPublicScreenState();
}

class _ChatPublicScreenState extends State<ChatPublicScreen> {
  late final ChatPublicCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
      return BlocProvider<ChatPublicCubit>(
        create: (context) => _cubit,
        child: BlocConsumer<ChatPublicCubit, ChatPublicState>(
            listener: (context, state) {
          if (state.token != null) {
            BlocProvider.of<AuthCubit>(context).logOut();
            BlocProvider.of<AuthCubit>(context)
                .logInWithToken(token: state.token!);
          }
        }, builder: (context, state) {
          return authState.isLoggedIn && state.conversation != null
              ? Scaffold(
                  appBar: AppBar(
                    primary: true,
                    automaticallyImplyLeading: true,
                    centerTitle: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)?.provided_by('') ??
                            ''),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).go(homePath);
                          },
                          child: Image.asset(
                            'assets/images/priorli_horizontal.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: MessageScreen(
                    channelId: state.conversation?.channelId ?? '',
                    conversationId: state.conversation?.id ?? '',
                    messageType: state.conversation?.type ?? '',
                  ),
                )
              : Scaffold(
                  body: authState.isLoggedIn
                      ? const SupportMessageDialog()
                      : EnterEmailToChatDialog(onSubmitData: ({String? email}) {
                          _cubit
                              .startChatbotConversation(
                                email: email,
                                countryCode: 'fi',
                                conversationName:
                                    AppLocalizations.of(context)?.housing_gpt,
                                languageCode: context
                                        .read<SettingCubit>()
                                        .state
                                        .languageCode ??
                                    '',
                              )
                              .then((value) => {});
                        }),
                );
        }),
      );
    });
  }
}

class SupportMessageDialog extends StatefulWidget {
  const SupportMessageDialog({super.key});

  @override
  State<SupportMessageDialog> createState() => _SupportMessageDialogState();
}

class _SupportMessageDialogState extends State<SupportMessageDialog> {
  final _textEditingController = TextEditingController();
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomFormField(
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.sentences,
        hintText: AppLocalizations.of(context)!.support_subject,
        textEditingController: _textEditingController,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).canPop()
                  ? Navigator.of(context).pop()
                  : GoRouter.of(context).go('/');
            },
            child: Text(AppLocalizations.of(context)!.cancel)),
        OutlinedButton(
          onPressed: () {
            BlocProvider.of<ChatPublicCubit>(context).startSupportConversation(
                conversationName: _textEditingController.text,
                languageCode:
                    context.read<SettingCubit>().state.languageCode ?? 'fi',
                countryCode: 'fi');
          },
          child: Text(AppLocalizations.of(context)!.start),
        )
      ],
    );
  }
}

class EnterEmailToChatDialog extends StatefulWidget {
  const EnterEmailToChatDialog({
    super.key,
    required this.onSubmitData,
  });
  final Function({String? email}) onSubmitData;

  @override
  State<EnterEmailToChatDialog> createState() => _EnterEmailToChatDialogState();
}

class _EnterEmailToChatDialogState extends State<EnterEmailToChatDialog> {
  final _emailController = TextEditingController();
  bool anonymous = false;
  bool terms = false;

  @override
  dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const AppPreferences(
        mini: true,
        verticalMini: false,
      ),
      title: Text(AppLocalizations.of(context)!.enter_email_to_chat_title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomFormField(
                enabled: !anonymous,
                hintText: AppLocalizations.of(context)!.email,
                helperText: AppLocalizations.of(context)!.email_chat_helper,
                textEditingController: _emailController,
                autoValidate: true,
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) => value!.isValidEmail
                    ? null
                    : AppLocalizations.of(context)!.email_address_error,
              ),
            ),
            /*Text(AppLocalizations.of(context)!.or),
            SwitchListTile(
                value: anonymous,
                onChanged: (onChanged) {
                  setState(() {
                    anonymous = onChanged;
                  });
                },
                title: Text(AppLocalizations.of(context)!.anonymous_chat)),*/
            TermsAndPolicies(
              accepted: terms,
              onCheckChanged: (p0) {
                setState(() {
                  terms = p0;
                });
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: terms &&
                    (_emailController.text.isValidEmail || anonymous)
                ? () {
                    widget.onSubmitData(
                        email:
                            (anonymous || !_emailController.text.isValidEmail)
                                ? null
                                : _emailController.text);
                  }
                : null,
            child: Text(AppLocalizations.of(context)!.start))
      ],
    );
  }
}

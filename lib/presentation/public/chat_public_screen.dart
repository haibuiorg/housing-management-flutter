import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/auth_cubit.dart';
import 'package:priorli/auth_state.dart';
import 'package:priorli/presentation/home/home_screen.dart';
import 'package:priorli/presentation/public/chat_public_cubit.dart';
import 'package:priorli/presentation/public/chat_public_state.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:priorli/service_locator.dart';
import 'package:priorli/setting_cubit.dart';
import '../message/message_screen.dart';
import 'onboarding_screen.dart';

const publicChatScreenPath = '/housing-gpt';

class ChatPublicScreen extends StatefulWidget {
  const ChatPublicScreen({super.key, this.isAdminChat = false});
  final bool isAdminChat;

  @override
  State<ChatPublicScreen> createState() => _ChatPublicScreenState();
}

class _ChatPublicScreenState extends State<ChatPublicScreen> {
  late final ChatPublicCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseAnalytics.instance.logTutorialBegin();
    });
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
            FirebaseAnalytics.instance.logTutorialComplete();
          }
        }, builder: (context, state) {
          return authState.isLoggedIn && state.conversation != null
              ? Scaffold(
                  appBar: AppBar(
                    primary: true,
                    automaticallyImplyLeading: false,
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
                      ? SupportMessageDialog(
                          isAdminChat: widget.isAdminChat,
                        )
                      : const OnboardingScreen());
        }),
      );
    });
  }
}

class SupportMessageDialog extends StatefulWidget {
  const SupportMessageDialog({super.key, this.isAdminChat = false});
  final bool isAdminChat;

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
                isAdminChat: widget.isAdminChat,
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

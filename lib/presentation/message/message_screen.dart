import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/file_selector/file_selector.dart';
import 'package:priorli/presentation/message/message_cubit.dart';
import 'package:priorli/presentation/message/message_state.dart';
import 'package:priorli/service_locator.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:priorli/setting_state.dart';
import '../../core/utils/constants.dart';
import '../shared/app_lottie_animation.dart';
import 'message_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const messagePath = '/message';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.channelId,
    required this.messageType,
    required this.conversationId,
  });
  final String channelId;
  final String messageType;
  final String conversationId;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final _bodyController = TextEditingController();
  final _scrollController = ScrollController();
  late final MessageCubit _cubit;

  @override
  void initState() {
    _cubit = serviceLocator<MessageCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _bodyController.dispose();
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  _showJoinConversationChannelDialog() {
    showDialog(
        context: context,
        builder: (builder) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.join_this_channel),
              content: Text(AppLocalizations.of(context)!.join_channel_confirm),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      _cubit.joinConversation();
                      Navigator.pop(builder, true);
                    },
                    child: Text(AppLocalizations.of(context)!.sure)),
              ],
            ));
  }

  _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageCubit>(
      create: (_) => _cubit
        ..init(
            channelId: widget.channelId,
            conversationId: widget.conversationId,
            messageType: widget.messageType,
            appLanguage: AppLocalizations.of(context)!.localeName),
      child:
          BlocConsumer<MessageCubit, MessageState>(listener: (context, state) {
        if (state.messageList?.isNotEmpty == true) {
          _scrollToBottom();
        }
      }, builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(state.conversation?.name.capitalize() ??
                  AppLocalizations.of(context)!.messages),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(AppLocalizations.of(context)!.show_messages_in),
                ),
                BlocBuilder<SettingCubit, SettingState>(
                    builder: (context, settingState) {
                  return DropdownButton<String>(
                    enableFeedback: true,
                    hint: Text(AppLocalizations.of(context)!.language),
                    dropdownColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    value: state.translatedLanguageCode ??
                        settingState.languageCode,
                    elevation: 16,
                    borderRadius: BorderRadius.circular(8),
                    underline: Container(
                      height: 0,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    onChanged: (String? value) {
                      _cubit.switchLanguage(value);
                    },
                    items: [...settingState.appSupportLanguageCode!, 'Original']
                        .toList()
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                            AppLocalizations.of(context)!.language_code(value)),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
            body: Column(children: [
              Expanded(
                flex: 2,
                child: state.isLoading == true
                    ? const Center(
                        child: AppLottieAnimation(loadingResource: 'apartment'),
                      )
                    : ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: state.messageList?.length ?? 0,
                        itemBuilder: (context, index) {
                          final message = state.messageList?[index];
                          return message != null
                              ? MessageItem(
                                  translatedLanguageCode:
                                      state.translatedLanguageCode,
                                  message: message,
                                  isMyMessage:
                                      state.user?.userId == message.senderId,
                                )
                              : const SizedBox.shrink();
                        }),
              ),
              SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                    child: Column(
                      children: [
                        state.conversation?.type == messageTypeBotSupport
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                    onPressed: () {
                                      _cubit.inviteHumanToJoin();
                                    },
                                    child: Text(AppLocalizations.of(context)
                                            ?.ask_human_join ??
                                        '')),
                              )
                            : FileSelector(
                                onCompleteUploaded:
                                    BlocProvider.of<MessageCubit>(context)
                                        .updatePendingStorageItem,
                                autoUpload: true,
                              ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextFormField(
                                  controller: _bodyController,
                                  minLines: 3,
                                  maxLines: 10,
                                  autofocus: true,
                                  enabled: state.conversation?.joined == true,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .message_title,
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: state.conversation?.joined == true
                                    ? () {
                                        BlocProvider.of<MessageCubit>(context)
                                            .sendMessage(_bodyController.text);
                                        _bodyController.clear();
                                      }
                                    : () {
                                        _showJoinConversationChannelDialog();
                                      },
                                child: Text(state.conversation?.joined == true
                                    ? AppLocalizations.of(context)!.send
                                    : AppLocalizations.of(context)!.join)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]));
      }),
    );
  }
}

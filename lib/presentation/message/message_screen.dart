import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/message/message_cubit.dart';
import 'package:priorli/presentation/message/message_state.dart';
import 'package:priorli/service_locator.dart';
import 'message_item.dart';

const messagePath = '/message';

class MessageScreen extends StatefulWidget {
  const MessageScreen(
      {super.key,
      required this.channelId,
      required this.messageType,
      required this.conversationId});
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
        builder: (context) => AlertDialog(
              title: const Text('Join this channel'),
              content: const Text(
                  'Do you want to join this channel and start discussion'),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      _cubit.joinConversation();
                      Navigator.pop(context, true);
                    },
                    child: const Text('Sure!'))
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
            messageType: widget.messageType),
      child:
          BlocConsumer<MessageCubit, MessageState>(listener: (context, state) {
        if (state.messageList?.isNotEmpty == true) {
          _scrollToBottom();
        }
      }, builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
                title:
                    Text(state.conversation?.name.capitalize() ?? 'Message')),
            body: Column(children: [
              Expanded(
                flex: 2,
                child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: state.messageList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final message = state.messageList?[index];
                      return message != null
                          ? MessageItem(
                              message: message,
                              isMyMessage:
                                  state.user?.userId == message.senderId,
                            )
                          : const SizedBox.shrink();
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                          decoration: const InputDecoration(
                            hintText: 'Message',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
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
                            ? 'Send'
                            : 'Join')),
                  ],
                ),
              )
            ]));
      }),
    );
  }
}

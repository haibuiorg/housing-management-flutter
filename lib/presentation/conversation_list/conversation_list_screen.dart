import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_cubit.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_state.dart';
import 'package:priorli/service_locator.dart';

import '../message/message_screen.dart';
import '../shared/conversation_item.dart';

const conversationListPath = '/conversations';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConversationListCubit>(
      create: (_) => serviceLocator<ConversationListCubit>(),
      child: BlocConsumer<ConversationListCubit, ConversationListState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                body: CustomScrollView(
              clipBehavior: Clip.none,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                        top: MediaQuery.of(context).padding.top),
                    child: Text('Messages from companies',
                        style: Theme.of(context).textTheme.displaySmall),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final conversation = state.conversationList?[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: conversation != null
                          ? ConversationItem(
                              onPressed: () => GoRouter.of(context).push(
                                  '$messagePath/${conversation.type}/${conversation.channelId}/${conversation.id}'),
                              conversation: conversation,
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                  childCount: state.conversationList?.length ?? 0,
                )),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Text('Others',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ));
          }),
    );
  }
}

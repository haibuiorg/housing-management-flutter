import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_cubit.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_state.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
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
                body: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: CustomScrollView(
                clipBehavior: Clip.none,
                slivers: [
                  const SliverToBoxAdapter(
                      child: FullWidthTitle(
                    title: 'Messages from companies',
                  )),
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
                  const SliverToBoxAdapter(
                      child: FullWidthTitle(
                    title: 'Fault reports',
                  )),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final conversation = state.faultConversationList?[index];
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
                    childCount: state.faultConversationList?.length ?? 0,
                  )),
                  const SliverToBoxAdapter(
                    child: FullWidthTitle(
                      title: 'Support messages',
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final conversation =
                          state.supportConversationList?[index];
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
                    childCount: state.supportConversationList?.length ?? 0,
                  )),
                ],
              ),
            ));
          }),
    );
  }
}
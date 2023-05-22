import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_cubit.dart';
import 'package:priorli/presentation/conversation_list/conversation_list_state.dart';
import 'package:priorli/presentation/public/chat_public_screen.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';
import 'package:priorli/service_locator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../message/message_screen.dart';
import '../shared/app_lottie_animation.dart';
import '../shared/conversation_item.dart';

const conversationListPath = '/conversations';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key, this.isFromAdmin = false});
  final bool isFromAdmin;

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  late final ConversationListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<ConversationListCubit>()..init(widget.isFromAdmin);
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  _showStartDialog() {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (builder) {
          return FractionallySizedBox(
              heightFactor: 0.95,
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Center(
                          child: Container(
                        margin: const EdgeInsets.all(12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface,
                            borderRadius: BorderRadius.circular(8)),
                      )),
                      const Expanded(child: ChatPublicScreen()),
                    ],
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConversationListCubit>(
      create: (_) => _cubit,
      child: BlocConsumer<ConversationListCubit, ConversationListState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                floatingActionButton: FloatingActionButton.small(
                  onPressed: _showStartDialog,
                  child: const Icon(Icons.message_rounded),
                ),
                body: Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: state.conversationList?.isEmpty == true &&
                          state.supportConversationList?.isEmpty == true &&
                          state.faultConversationList?.isEmpty == true
                      ? const Center(
                          child: SizedBox(
                            width: 300,
                            height: 300,
                            child: AppLottieAnimation(
                              loadingResource: 'message',
                            ),
                          ),
                        )
                      : const MessageListWidget(),
                ));
          }),
    );
  }
}

class MessageListWidget extends StatelessWidget {
  const MessageListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationListCubit, ConversationListState>(
      builder: (context, state) => CustomScrollView(
        clipBehavior: Clip.none,
        slivers: [
          if (state.conversationList?.isNotEmpty == true)
            SliverToBoxAdapter(
                child: FullWidthTitle(
              title: AppLocalizations.of(context)!.from_compamies,
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
          if (state.faultConversationList?.isNotEmpty == true)
            SliverToBoxAdapter(
                child: FullWidthTitle(
              title: AppLocalizations.of(context)!.fault_reports,
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
          if (state.supportConversationList?.isNotEmpty == true)
            SliverToBoxAdapter(
              child: FullWidthTitle(
                title: AppLocalizations.of(context)!.support_requests,
              ),
            ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final conversation = state.supportConversationList?[index];
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
    );
  }
}

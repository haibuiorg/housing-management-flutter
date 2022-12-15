import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';

class ConversationListState extends Equatable {
  final List<Conversation>? conversationList;
  final List<Conversation>? supportConversationList;

  const ConversationListState(
      {this.conversationList, this.supportConversationList});

  @override
  List<Object?> get props => [conversationList, supportConversationList];

  ConversationListState copyWith(
          {List<Conversation>? conversationList,
          List<Conversation>? supportConversationList}) =>
      ConversationListState(
          conversationList: conversationList ?? this.conversationList,
          supportConversationList:
              supportConversationList ?? this.conversationList);
}

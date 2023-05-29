import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';

class ConversationListState extends Equatable {
  final List<Conversation>? conversationList;
  final List<Conversation>? supportConversationList;
  final List<Conversation>? faultConversationList;
  final List<Conversation>? chatbotConverstionList;

  const ConversationListState(
      {this.conversationList,
      this.chatbotConverstionList,
      this.supportConversationList,
      this.faultConversationList});

  @override
  List<Object?> get props => [
        conversationList,
        supportConversationList,
        faultConversationList,
        chatbotConverstionList
      ];

  ConversationListState copyWith(
          {List<Conversation>? conversationList,
          List<Conversation>? supportConversationList,
          List<Conversation>? faultConversationList,
          List<Conversation>? chatbotConverstionList}) =>
      ConversationListState(
          faultConversationList:
              faultConversationList ?? this.faultConversationList,
          conversationList: conversationList ?? this.conversationList,
          supportConversationList:
              supportConversationList ?? this.conversationList,
          chatbotConverstionList:
              chatbotConverstionList ?? this.chatbotConverstionList);
}

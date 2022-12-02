import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';

class ConversationListState extends Equatable {
  final List<Conversation>? conversationList;

  const ConversationListState({this.conversationList});

  @override
  List<Object?> get props => [conversationList];

  ConversationListState copyWith({
    List<Conversation>? conversationList,
  }) =>
      ConversationListState(
        conversationList: conversationList ?? this.conversationList,
      );
}

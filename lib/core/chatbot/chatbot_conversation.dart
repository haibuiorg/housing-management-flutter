import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';

import 'chatbot_conversation_model.dart';

class ChatbotConversation extends Equatable {
  final Conversation conversation;
  final String? token;

  const ChatbotConversation({required this.conversation, this.token});

  factory ChatbotConversation.modelToEntity(ChatbotConversationModel model) =>
      ChatbotConversation(
        conversation:
            Conversation.modelToEntity(conversationModel: model.conversation),
        token: model.token,
      );
  @override
  List<Object?> get props => [conversation, token];
}

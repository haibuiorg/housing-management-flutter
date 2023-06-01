import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/chatbot/chatbot_conversation.dart';
import 'package:priorli/presentation/public/chat_public_state.dart';

import '../../core/chatbot/start_chatbot_conversation.dart';
import '../../core/messaging/entities/conversation.dart';
import '../../core/messaging/usecases/start_support_conversation.dart';

class ChatPublicCubit extends Cubit<ChatPublicState> {
  final StartChatbotConversation _startChatbotConversation;
  final StartSupportConversation _startSupportConversation;
  ChatPublicCubit(
      this._startChatbotConversation, this._startSupportConversation)
      : super(const ChatPublicState());

  Future<bool> startChatbotConversation({
    String? email,
    String? phone,
    String? lastName,
    String? firstName,
    String? conversationName,
    required String countryCode,
    required String languageCode,
  }) async {
    final startChatbotConversationResult =
        await _startChatbotConversation(StartChatbotConversationParams(
      countryCode: countryCode,
      languageCode: languageCode,
      email: email,
      phone: phone,
      lastName: lastName,
      firstName: firstName,
      conversationName: conversationName,
    ));
    if (startChatbotConversationResult is ResultSuccess<ChatbotConversation>) {
      emit(state.copyWith(
        conversation: startChatbotConversationResult.data.conversation,
        token: startChatbotConversationResult.data.token,
      ));
      return true;
    }
    return false;
  }

  Future<void> startSupportConversation({
    required String conversationName,
    required String countryCode,
    required String languageCode,
    bool isAdminChat = false,
  }) async {
    final conversationResult = await _startSupportConversation(
        StartSupportConversationParams(
            countryCode: countryCode,
            name: conversationName,
            isAdminChat: isAdminChat,
            languageCode: languageCode));
    if (conversationResult is ResultSuccess<Conversation>) {
      emit(state.copyWith(conversation: conversationResult.data));
    }
  }
}

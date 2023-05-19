import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/chatbot/chatbot_conversation.dart';
import 'package:priorli/core/chatbot/chatbot_repository.dart';

class StartChatbotConversation
    extends UseCase<ChatbotConversation, StartChatbotConversationParams> {
  final ChatbotRepository chatbotRepository;

  StartChatbotConversation({required this.chatbotRepository});

  @override
  Future<Result<ChatbotConversation>> call(
      StartChatbotConversationParams params) {
    return chatbotRepository.startNewChatbotConversation(
      languageCode: params.languageCode,
      countryCode: params.countryCode,
      email: params.email,
      phone: params.phone,
      lastName: params.lastName,
      firstName: params.firstName,
      conversationName: params.conversationName,
    );
  }
}

class StartChatbotConversationParams extends Equatable {
  final String languageCode;
  final String countryCode;
  final String? email;
  final String? phone;
  final String? lastName;
  final String? firstName;
  final String? conversationName;

  const StartChatbotConversationParams({
    required this.countryCode,
    required this.languageCode,
    this.email,
    this.phone,
    this.lastName,
    this.firstName,
    this.conversationName,
  });
  @override
  List<Object?> get props => [
        languageCode,
        countryCode,
        email,
        phone,
        lastName,
        firstName,
        conversationName,
      ];
}

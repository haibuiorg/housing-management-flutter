import 'dart:js_interop';

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class StartSupportConversation
    extends UseCase<Conversation, StartSupportConversationParams> {
  final MessagingRepository messagingRepository;

  StartSupportConversation({required this.messagingRepository});

  @override
  Future<Result<Conversation>> call(StartSupportConversationParams params) {
    return messagingRepository.startSupportConversation(
        countryCode: params.countryCode,
        languageCode: params.languageCode,
        startWithBot: params.startWithBot,
        name: params.name,
        isAdminChat: params.isAdminChat,
        userId: params.userId);
  }
}

class StartSupportConversationParams extends Equatable {
  final String? userId;
  final String countryCode;
  final String languageCode;
  final String name;
  final bool startWithBot;
  final bool isAdminChat;

  const StartSupportConversationParams(
      {this.userId,
      required this.countryCode,
      required this.name,
      this.isAdminChat = false,
      this.startWithBot = true,
      required this.languageCode});

  @override
  List<Object?> get props =>
      [userId, name, languageCode, countryCode, isAdminChat, startWithBot];
}

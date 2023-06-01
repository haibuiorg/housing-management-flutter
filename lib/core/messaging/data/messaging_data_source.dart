import 'package:priorli/core/messaging/models/conversation_model.dart';

import '../entities/message.dart';
import '../models/message_model.dart';

abstract class MessagingDataSource {
  Stream<List<MessageModel>> getCommunityMessages({
    required String companyId,
    required String conversationId,
  });
  Stream<List<MessageModel>> getSupportMessages({
    required String supportChannelId,
    required String conversationId,
    required bool isAdminChat,
  });
  Future<MessageModel> sendMessage(
      {required String channelId,
      required String conversationId,
      required String messageType,
      required String message,
      List<String>? storageItems});
  Future<ConversationModel> startConversation({
    required String messageType,
    required String channelId,
    required String name,
  });
  Future<ConversationModel> startSupportConversation({
    required String countryCode,
    required String languageCode,
    required String name,
    required bool isAdminChat,
    required bool startWithBot,
  });
  Future<ConversationModel> joinConversation({
    required String messageType,
    required String channelId,
    required String conversationId,
  });
  Future<ConversationModel> setConversationSeen({
    required String messageType,
    required String channelId,
    required String conversationId,
  });
  Future<ConversationModel> changeConversationType({
    required String messageType,
    required String channelId,
    required String conversationId,
  });
  Future<ConversationModel> getConversationDetail({
    required String messageType,
    required String channelId,
    required String conversationId,
  });
  Stream<List<ConversationModel>> getConversationLists({
    required bool isFromAdmin,
    required String userId,
  });
  Stream<List<ConversationModel>> getCompanyConversationLists({
    required String companyId,
  });
  Stream<List<ConversationModel>> getAdminBotConversationLists({
    required String userId,
  });
}

import 'package:priorli/core/messaging/models/conversation_model.dart';

import '../entities/message.dart';
import '../models/message_model.dart';

abstract class MessagingDataSource {
  Stream<List<MessageModel>> getCommunityMessages({
    required String companyId,
    required String conversationId,
  });
  Future<MessageModel> sendCommunityMessage({
    required String companyId,
    required Message message,
    required String conversationId,
  });
  Stream<List<MessageModel>> getSupportMessages({
    required String supportChannelId,
    required String conversationId,
  });
  Future<MessageModel> sendSupportMessage(
      {required String supportChannelId,
      required String conversationId,
      required Message message});
  Future<MessageModel> sendMessage(
      {required String channelId,
      required String conversationId,
      required String messageType,
      required String message});
  Future<ConversationModel> startConversation({
    required String messageType,
    required String channelId,
    required String name,
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
  Future<ConversationModel> getConversationDetail({
    required String messageType,
    required String channelId,
    required String conversationId,
  });
  Stream<List<ConversationModel>> getConversationLists({
    required String messageType,
    required String userId,
  });
  Stream<List<ConversationModel>> getCompanyConversationLists({
    required String companyId,
  });
}

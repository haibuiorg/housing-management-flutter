import '../../base/result.dart';
import '../entities/message.dart';
import '../entities/conversation.dart';

abstract class MessagingRepository {
  Stream<List<Message>> getCommunityMessages({
    required String companyId,
    required String conversationId,
  });
  Stream<List<Message>> getSupportMessages({
    required String supportChannelId,
    required String conversationId,
  });
  Future<Result<Message>> sendMessage(
      {required String channelId,
      required String conversationId,
      required String message,
      required String messageType,
      List<String>? storageItems});
  Stream<List<Conversation>> getConversationLists({
    required bool isFromAdmin,
    required String userId,
  });
  Stream<List<Conversation>> getCompanyConversationLists({
    required String companyId,
    required String userId,
  });
  Future<Result<Conversation>> startConversation({
    required String messageType,
    required String userId,
    required String channelId,
    required String name,
  });
  Future<Result<Conversation>> startSupportConversation({
    String? userId,
    required String countryCode,
    required String languageCode,
    required String name,
  });
  Future<Result<Conversation>> joinConversation({
    required String messageType,
    required String userId,
    required String channelId,
    required String conversationId,
  });
  Future<Result<Conversation>> setConversationSeen({
    required String messageType,
    required String userId,
    required String channelId,
    required String conversationId,
  });
  Future<Result<Conversation>> getConversationDetail({
    required String messageType,
    required String channelId,
    required String conversationId,
    required String userId,
  });
}

import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/chatbot/chatbot_conversation.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

abstract class ChatbotRepository {
  Future<Result<List<StorageItem>>> addGenericReferenceDoc({
    required List<String> storageLinks,
    required String languageCode,
    required String docType,
    required String indexName,
  });
  Future<Result<bool>> addIndex({
    required String indexName,
    int? vectorDimension,
  });

  Future<Result<List<String>>> getIndexes();

  Future<Result<ChatbotConversation>> startNewChatbotConversation({
    required String languageCode,
    required String countryCode,
    String? email,
    String? phone,
    String? lastName,
    String? firstName,
    String? conversationName,
  });
}

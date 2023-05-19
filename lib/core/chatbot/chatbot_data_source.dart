import 'package:priorli/core/chatbot/chatbot_conversation_model.dart';

import '../storage/models/storage_item_model.dart';

abstract class ChatbotDataSource {
  Future<List<StorageItemModel>> addGenericReferenceDoc({
    required List<String> storageLinks,
    required String languageCode,
    required String docType,
    required String indexName,
  });
  Future<bool> addIndex({
    required String indexName,
    int? vectorDimension,
  });
  Future<List<String>> getIndexes();

  Future<ChatbotConversationModel> startNewChatbotConversation({
    required String languageCode,
    required String countryCode,
    String? email,
    String? phone,
    String? lastName,
    String? firstName,
    String? conversationName,
  });
}

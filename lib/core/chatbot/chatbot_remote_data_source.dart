import 'package:dio/dio.dart';
import 'package:priorli/core/base/exceptions.dart';
import 'package:priorli/core/chatbot/chatbot_conversation_model.dart';
import 'package:priorli/core/chatbot/chatbot_data_source.dart';
import 'package:priorli/core/storage/models/storage_item_model.dart';

class ChatbotRemoteDataSource implements ChatbotDataSource {
  final Dio client;

  ChatbotRemoteDataSource({required this.client});
  @override
  Future<List<StorageItemModel>> addGenericReferenceDoc(
      {required List<String> storageLinks,
      required String languageCode,
      required String indexName,
      required String docType}) async {
    try {
      final data = {
        'storage_links': storageLinks,
        'language_code': languageCode,
        'doc_type': docType,
        'index_name': indexName,
      };
      final result = await client.post('/admin/add_reference_doc', data: data);
      return (result.data as List<dynamic>)
          .map((e) => StorageItemModel.fromJson(e))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<bool> addIndex(
      {required String indexName, int? vectorDimension}) async {
    try {
      final data = {
        'index_name': indexName,
        'vector_dimension': vectorDimension,
      };
      data.removeWhere((key, value) => value == null);
      final result = await client.post('/admin/add_index', data: data);
      return (result.data as bool);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<String>> getIndexes() async {
    try {
      final result = await client.get('/admin/reference_indexes');
      return (result.data as List<dynamic>).map((e) => e.toString()).toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ChatbotConversationModel> startNewChatbotConversation(
      {String? email,
      String? phone,
      String? lastName,
      String? firstName,
      String? conversationName,
      required String languageCode,
      required String countryCode}) async {
    try {
      final data = {
        'email': email,
        'phone': phone,
        'last_name': lastName,
        'first_name': firstName,
        'conversation_name': conversationName,
        'language_code': languageCode,
        'country_code': countryCode
      };
      data.removeWhere((key, value) => value == null);
      final result = await client.post('/chatbot', data: data);
      return ChatbotConversationModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

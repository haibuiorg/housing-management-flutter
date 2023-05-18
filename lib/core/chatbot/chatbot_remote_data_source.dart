import 'package:dio/dio.dart';
import 'package:priorli/core/base/exceptions.dart';
import 'package:priorli/core/chatbot/chatbot_data_source.dart';
import 'package:priorli/core/storage/models/storage_item_model.dart';

class ChatbotRemoteDataSource implements ChatbotDataSource {
  final Dio client;

  ChatbotRemoteDataSource({required this.client});
  @override
  Future<List<StorageItemModel>> addGenericReferenceDoc(
      {required List<String> storageLinks,
      required String languageCode,
      required String docType}) async {
    try {
      final data = {
        'storage_links': storageLinks,
        'language_code': languageCode,
        'doc_type': docType
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
}

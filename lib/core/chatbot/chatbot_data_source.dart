import '../storage/models/storage_item_model.dart';

abstract class ChatbotDataSource {
  Future<List<StorageItemModel>> addGenericReferenceDoc({
    required List<String> storageLinks,
    required String languageCode,
    required String docType,
  });
  Future<bool> addIndex({
    required String indexName,
    int? vectorDimension,
  });
}

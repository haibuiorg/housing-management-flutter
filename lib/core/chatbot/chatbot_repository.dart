import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

abstract class ChatbotRepository {
  Future<Result<List<StorageItem>>> addGenericReferenceDoc({
    required List<String> storageLinks,
    required String languageCode,
    required String docType,
  });
  Future<Result<bool>> addIndex({
    required String indexName,
    int? vectorDimension,
  });
}

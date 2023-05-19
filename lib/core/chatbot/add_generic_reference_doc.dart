import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/chatbot/chatbot_repository.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

class AddGenericReferenceDoc
    extends UseCase<List<StorageItem>, AddGenericReferenceDocParams> {
  final ChatbotRepository chatbotRepository;

  AddGenericReferenceDoc({required this.chatbotRepository});

  @override
  Future<Result<List<StorageItem>>> call(AddGenericReferenceDocParams params) {
    return chatbotRepository.addGenericReferenceDoc(
      storageLinks: params.storageLinks,
      languageCode: params.languageCode,
      indexName: params.indexName,
      docType: params.docType ?? params.indexName,
    );
  }
}

class AddGenericReferenceDocParams extends Equatable {
  final List<String> storageLinks;
  final String languageCode;
  final String indexName;
  final String? docType;

  const AddGenericReferenceDocParams(
      {required this.storageLinks,
      required this.languageCode,
      required this.indexName,
      this.docType});
  @override
  List<Object?> get props => [storageLinks, languageCode, docType, indexName];
}

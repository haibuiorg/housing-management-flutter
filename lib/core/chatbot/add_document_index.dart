import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/chatbot/chatbot_repository.dart';

class AddDocumentIndex extends UseCase<bool, AddDocumentIndexParams> {
  final ChatbotRepository chatbotRepository;

  AddDocumentIndex({required this.chatbotRepository});

  @override
  Future<Result<bool>> call(AddDocumentIndexParams params) {
    return chatbotRepository.addIndex(
      vectorDimension: params.vectorDimension,
      indexName: params.indexName,
    );
  }
}

class AddDocumentIndexParams extends Equatable {
  final String indexName;
  final int? vectorDimension;

  const AddDocumentIndexParams({
    required this.indexName,
    required this.vectorDimension,
  });
  @override
  List<Object?> get props => [indexName, vectorDimension];
}

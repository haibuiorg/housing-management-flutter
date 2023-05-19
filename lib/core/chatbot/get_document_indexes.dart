import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/chatbot/chatbot_repository.dart';

class GetDocumentIndexes extends UseCase<List<String>, NoParams> {
  final ChatbotRepository chatbotRepository;

  GetDocumentIndexes({required this.chatbotRepository});

  @override
  Future<Result<List<String>>> call(NoParams params) {
    return chatbotRepository.getIndexes();
  }
}

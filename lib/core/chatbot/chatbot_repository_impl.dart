import 'package:priorli/core/base/exceptions.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/chatbot/chatbot_conversation.dart';
import 'package:priorli/core/chatbot/chatbot_data_source.dart';
import 'package:priorli/core/chatbot/chatbot_repository.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../base/failure.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotDataSource chatbotDataSource;

  ChatbotRepositoryImpl({required this.chatbotDataSource});

  @override
  Future<Result<List<StorageItem>>> addGenericReferenceDoc(
      {required List<String> storageLinks,
      required String languageCode,
      required String indexName,
      required String docType}) async {
    try {
      final result = await chatbotDataSource.addGenericReferenceDoc(
          storageLinks: storageLinks,
          languageCode: languageCode,
          indexName: indexName,
          docType: docType);
      return ResultSuccess(
          result.map((e) => StorageItem.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> addIndex(
      {required String indexName, int? vectorDimension}) async {
    try {
      final result = await chatbotDataSource.addIndex(
          indexName: indexName, vectorDimension: vectorDimension);
      return ResultSuccess(result);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<String>>> getIndexes() async {
    try {
      final result = await chatbotDataSource.getIndexes();
      return ResultSuccess(result);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<ChatbotConversation>> startNewChatbotConversation(
      {required String languageCode,
      required String countryCode,
      String? email,
      String? phone,
      String? lastName,
      String? firstName,
      String? conversationName}) async {
    try {
      final result = await chatbotDataSource.startNewChatbotConversation(
          languageCode: languageCode,
          countryCode: countryCode,
          email: email,
          phone: phone,
          lastName: lastName,
          firstName: firstName,
          conversationName: conversationName);
      return ResultSuccess(ChatbotConversation.modelToEntity(result));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/messaging/entities/message.dart';
import 'package:priorli/core/messaging/data/messaging_data_source.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import '../../base/exceptions.dart';
import '../../base/failure.dart';
import 'messaging_repository.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  final MessagingDataSource messagingDataSource;

  MessagingRepositoryImpl({required this.messagingDataSource});
  @override
  Stream<List<Message>> getCommunityMessages(
      {required String companyId, required String conversationId}) {
    return messagingDataSource
        .getCommunityMessages(
            companyId: companyId, conversationId: conversationId)
        .map((event) => event.map((e) => Message.modelToEntity(e)).toList());
  }

  @override
  Stream<List<Message>> getSupportMessages({
    required String supportChannelId,
    required String conversationId,
  }) {
    return messagingDataSource
        .getSupportMessages(
          conversationId: conversationId,
          supportChannelId: supportChannelId,
        )
        .map((event) => event.map((e) => Message.modelToEntity(e)).toList());
  }

  @override
  Future<Result<Message>> sendMessage(
      {required String channelId,
      required String conversationId,
      required String message,
      required String messageType,
      List<String>? storageItems}) async {
    try {
      final messageModel = await messagingDataSource.sendMessage(
          conversationId: conversationId,
          channelId: channelId,
          messageType: messageType,
          storageItems: storageItems,
          message: message);
      return ResultSuccess(Message.modelToEntity(messageModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Stream<List<Conversation>> getConversationLists(
      {required bool isFromAdmin, required String userId}) {
    return messagingDataSource
        .getConversationLists(
          isFromAdmin: isFromAdmin,
          userId: userId,
        )
        .map((event) => event
            .map((e) => Conversation.modelToEntity(
                conversationModel: e, userId: userId))
            .toList());
  }

  @override
  Stream<List<Conversation>> getCompanyConversationLists(
      {required String companyId, required String userId}) {
    return messagingDataSource
        .getCompanyConversationLists(
          companyId: companyId,
        )
        .map((event) => event
            .map((e) => Conversation.modelToEntity(
                conversationModel: e, userId: userId))
            .toList());
  }

  @override
  Future<Result<Conversation>> joinConversation(
      {required String messageType,
      required String userId,
      required String channelId,
      required String conversationId}) async {
    try {
      final conversationModel = await messagingDataSource.joinConversation(
          channelId: channelId,
          messageType: messageType,
          conversationId: conversationId);
      return ResultSuccess(Conversation.modelToEntity(
          conversationModel: conversationModel, userId: userId));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Conversation>> setConversationSeen(
      {required String messageType,
      required String userId,
      required String channelId,
      required String conversationId}) async {
    try {
      final conversationModel = await messagingDataSource.setConversationSeen(
          channelId: channelId,
          messageType: messageType,
          conversationId: conversationId);
      return ResultSuccess(Conversation.modelToEntity(
          conversationModel: conversationModel, userId: userId));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Conversation>> startConversation(
      {required String messageType,
      required String userId,
      required String channelId,
      required String name}) async {
    try {
      final conversationModel = await messagingDataSource.startConversation(
          channelId: channelId, messageType: messageType, name: name);
      return ResultSuccess(Conversation.modelToEntity(
          conversationModel: conversationModel, userId: userId));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Conversation>> getConversationDetail(
      {required String messageType,
      required String channelId,
      required String conversationId,
      required String userId}) async {
    try {
      final conversationModel = await messagingDataSource.getConversationDetail(
          channelId: channelId,
          messageType: messageType,
          conversationId: conversationId);
      return ResultSuccess(Conversation.modelToEntity(
          conversationModel: conversationModel, userId: userId));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Conversation>> startSupportConversation(
      {required String countryCode,
      String? userId,
      required String languageCode,
      required String name}) async {
    try {
      final conversationModel =
          await messagingDataSource.startSupportConversation(
              languageCode: languageCode, countryCode: countryCode, name: name);
      return ResultSuccess(Conversation.modelToEntity(
          conversationModel: conversationModel, userId: userId));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

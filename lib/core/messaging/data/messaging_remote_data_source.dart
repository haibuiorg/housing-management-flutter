import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:priorli/core/messaging/data/messaging_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:priorli/core/messaging/models/conversation_model.dart';

import '../../base/exceptions.dart';
import '../../utils/constants.dart';
import '../entities/message.dart';
import '../models/message_model.dart';

class MessagingRemoteDataSource implements MessagingDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  final String _messagePath = '/message';
  final Dio client;

  MessagingRemoteDataSource({
    required this.firestore,
    required this.client,
    required this.firebaseStorage,
  });

  @override
  Stream<List<MessageModel>> getCommunityMessages({
    required String companyId,
    required String conversationId,
  }) {
    return firestore
        .collection(housingCompanies)
        .doc(companyId)
        .collection(conversations)
        .doc(conversationId)
        .collection(messages)
        .orderBy(createdOn, descending: true)
        .limit(20)
        .snapshots()
        .map((it) {
      final newList =
          it.docs.map((e) => MessageModel.fromJson(e.data())).toList();
      return newList;
    });
  }

  @override
  Stream<List<MessageModel>> getSupportMessages({
    required String supportChannelId,
    required String conversationId,
  }) {
    return firestore
        .collection(supportChannels)
        .doc(supportChannelId)
        .collection(conversations)
        .doc(conversationId)
        .collection(messages)
        .orderBy(createdOn, descending: true)
        .limit(20)
        .snapshots()
        .map((it) {
      final newList =
          it.docs.map((e) => MessageModel.fromJson(e.data())).toList();
      return newList;
    });
  }

  @override
  Stream<List<ConversationModel>> getConversationLists({
    required bool isFromAdmin,
    required String userId,
  }) {
    Stream<List<ConversationModel>> query;
    try {
      query = isFromAdmin
          ? firestore
              .collectionGroup(conversations)
              .where(type, whereIn: [messageTypeSupport, messageTypeBotSupport])
              .orderBy(updatedOn, descending: true)
              .snapshots()
              .map((it) {
                final newList = it.docs
                    .map((e) => ConversationModel.fromJson(e.data()))
                    .toList();

                return newList;
              })
          : firestore
              .collectionGroup(conversations)
              .where(userIds, arrayContains: userId)
              //.where(type, isEqualTo: messageType)
              .orderBy(updatedOn, descending: true)
              .snapshots()
              .map((it) {
              final newList = it.docs
                  .map((e) => ConversationModel.fromJson(e.data()))
                  .toList();

              return newList;
            });
      return query;
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<MessageModel> sendMessage(
      {required String channelId,
      required String conversationId,
      required String messageType,
      required String message,
      List<String>? storageItems}) async {
    try {
      final Map<String, dynamic> data = {
        "channel_id": channelId,
        "conversation_id": conversationId,
        "type": messageType,
        "message": message,
        "storage_items": storageItems
      };
      try {
        final result = await client.post(_messagePath, data: data);
        return MessageModel.fromJson(result.data);
      } catch (error) {
        throw ServerException();
      }
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Stream<List<ConversationModel>> getCompanyConversationLists({
    required String companyId,
  }) {
    Stream<List<ConversationModel>> query;
    try {
      query = firestore
          .collection(housingCompanies)
          .doc(companyId)
          .collection(conversations)
          .orderBy(updatedOn, descending: true)
          //.where('type', isEqualTo: messageTypeCommunity)
          .snapshots()
          .map((it) {
        final newList =
            it.docs.map((e) => ConversationModel.fromJson(e.data())).toList();

        return newList;
      });
      return query;
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ConversationModel> joinConversation(
      {required String messageType,
      required String channelId,
      required String conversationId}) async {
    try {
      final Map<String, dynamic> data = {
        "channel_id": channelId,
        "conversation_id": conversationId,
        "type": messageType,
      };
      try {
        final result = await client.put('/join_conversation', data: data);
        return ConversationModel.fromJson(result.data);
      } catch (error) {
        throw ServerException();
      }
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ConversationModel> setConversationSeen(
      {required String messageType,
      required String channelId,
      required String conversationId}) async {
    try {
      final Map<String, dynamic> data = {
        "channel_id": channelId,
        "conversation_id": conversationId,
        "type": messageType,
      };
      try {
        final result = await client.put('/seen_conversation', data: data);
        return ConversationModel.fromJson(result.data);
      } catch (error) {
        throw ServerException();
      }
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ConversationModel> startConversation(
      {required String messageType,
      required String channelId,
      required String name}) async {
    try {
      final Map<String, dynamic> data = {
        "channel_id": channelId,
        "name": name,
        "type": messageType,
      };
      try {
        final result = await client.post('/start_conversation', data: data);
        return ConversationModel.fromJson(result.data);
      } catch (error) {
        throw ServerException();
      }
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ConversationModel> getConversationDetail(
      {required String messageType,
      required String channelId,
      required String conversationId}) async {
    try {
      final Map<String, dynamic> data = {
        "channel_id": channelId,
        "conversation_id": conversationId,
        "type": messageType,
      };
      final result = await client.get('/conversation', queryParameters: data);
      return ConversationModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ConversationModel> startSupportConversation(
      {required String countryCode,
      required String languageCode,
      required bool startWithBot,
      required String name}) async {
    try {
      final Map<String, dynamic> data = {
        "language_code": languageCode,
        "name": name,
        "country_code": countryCode,
        "type": startWithBot ? messageTypeBotSupport : messageTypeSupport,
      };
      try {
        final result = await client.post('/start_conversation', data: data);
        return ConversationModel.fromJson(result.data);
      } catch (error) {
        throw ServerException();
      }
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ConversationModel> changeConversationType(
      {required String messageType,
      required String channelId,
      required String conversationId}) async {
    try {
      final Map<String, dynamic> data = {
        "channel_id": channelId,
        "conversation_id": conversationId,
        "type": messageType,
      };
      final result = await client.put('/conversation/type', data: data);
      return ConversationModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

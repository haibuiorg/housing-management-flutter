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
  Future<MessageModel> sendCommunityMessage(
      {required String companyId,
      required String conversationId,
      required Message message}) async {
    try {
      final Map<String, dynamic> data = {
        "channel_id": companyId,
        "conversation_id": conversationId,
        "type": messageTypeCommunity,
        "message": message.message
      };
      try {
        final result = await client.post(_messagePath, data: data);
        return MessageModel.fromJson(result.data);
      } catch (error) {
        throw ServerException(error: error);
      }
    } catch (error) {
      throw ServerException(error: error);
    }
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
  Future<MessageModel> sendSupportMessage(
      {required String supportChannelId,
      required String conversationId,
      required Message message}) async {
    try {
      final Map<String, dynamic> data = {
        "channel_id": supportChannelId,
        "conversation_id": conversationId,
        "type": messageTypeSupport,
        "message": message.message
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
  Stream<List<ConversationModel>> getConversationLists({
    required String messageType,
    required String userId,
  }) {
    Stream<List<ConversationModel>> query;
    try {
      query = firestore
          .collectionGroup(conversations)
          .where(userIds, arrayContains: userId)
          //.where(type, isEqualTo: messageType)
          .orderBy(updatedOn, descending: true)
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
      required String name}) async {
    try {
      final Map<String, dynamic> data = {
        "language_code": languageCode,
        "name": name,
        "country_code": countryCode,
        "type": messageTypeSupport,
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
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatbot_conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatbotConversationModel _$ChatbotConversationModelFromJson(
        Map<String, dynamic> json) =>
    ChatbotConversationModel(
      ConversationModel.fromJson(json['conversation'] as Map<String, dynamic>),
      json['token'] as String?,
    );

Map<String, dynamic> _$ChatbotConversationModelToJson(
        ChatbotConversationModel instance) =>
    <String, dynamic>{
      'conversation': instance.conversation,
      'token': instance.token,
    };

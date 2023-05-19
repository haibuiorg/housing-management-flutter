import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:priorli/core/messaging/models/conversation_model.dart';

part 'chatbot_conversation_model.g.dart';

@JsonSerializable()
class ChatbotConversationModel extends Equatable {
  final ConversationModel conversation;
  final String? token;

  const ChatbotConversationModel(this.conversation, this.token);

  factory ChatbotConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ChatbotConversationModelFromJson(json);

  @override
  List<Object?> get props => [conversation, token];
}

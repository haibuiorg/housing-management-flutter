import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';

class ChatPublicState extends Equatable {
  final Conversation? conversation;
  final String? token;

  const ChatPublicState({this.conversation, this.token});

  ChatPublicState copyWith({Conversation? conversation, String? token}) {
    return ChatPublicState(
        conversation: conversation ?? this.conversation,
        token: token ?? this.token);
  }

  @override
  List<Object?> get props => [conversation, token];
}

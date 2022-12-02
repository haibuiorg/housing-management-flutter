import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/user/entities/user.dart';

import '../../core/messaging/entities/conversation.dart';
import '../../core/messaging/entities/message.dart';

class MessageState extends Equatable {
  final List<Message>? messageList;
  final String? messageType;
  final Conversation? conversation;
  final User? user;

  const MessageState(
      {this.messageList, this.messageType, this.user, this.conversation});

  MessageState copyWith(
          {List<Message>? messageList,
          String? messageType,
          User? user,
          Conversation? conversation}) =>
      MessageState(
          user: user ?? this.user,
          messageType: messageType ?? this.messageType,
          conversation: conversation ?? this.conversation,
          messageList: messageList ?? this.messageList);

  @override
  List<Object?> get props => [messageList, messageType, user, conversation];
}

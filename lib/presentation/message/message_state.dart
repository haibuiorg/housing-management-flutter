import 'package:equatable/equatable.dart';
import 'package:priorli/core/user/entities/user.dart';

import '../../core/messaging/entities/conversation.dart';
import '../../core/messaging/entities/message.dart';

class MessageState extends Equatable {
  final List<Message>? messageList;
  final String? messageType;
  final Conversation? conversation;
  final User? user;
  final List<String>? pendingStorageItems;
  final String? translatedLanguageCode;
  final bool? isLoading;

  const MessageState(
      {this.messageList,
      this.messageType,
      this.user,
      this.isLoading,
      this.translatedLanguageCode,
      this.conversation,
      this.pendingStorageItems});

  MessageState copyWith(
          {List<Message>? messageList,
          String? messageType,
          User? user,
          bool? isLoading,
          String? translatedLanguageCode,
          List<String>? pendingStorageItems,
          Conversation? conversation}) =>
      MessageState(
          isLoading: isLoading ?? this.isLoading,
          pendingStorageItems: pendingStorageItems ?? this.pendingStorageItems,
          user: user ?? this.user,
          translatedLanguageCode:
              translatedLanguageCode ?? this.translatedLanguageCode,
          messageType: messageType ?? this.messageType,
          conversation: conversation ?? this.conversation,
          messageList: messageList ?? this.messageList);

  @override
  List<Object?> get props => [
        messageList,
        messageType,
        user,
        conversation,
        pendingStorageItems,
        isLoading,
        translatedLanguageCode
      ];
}

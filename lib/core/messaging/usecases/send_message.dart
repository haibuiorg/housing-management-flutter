import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/message.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class SendMessage extends UseCase<Message, SendMessageParams> {
  final MessagingRepository messagingRepository;

  SendMessage({required this.messagingRepository});

  @override
  Future<Result<Message>> call(SendMessageParams params) {
    return messagingRepository.sendMessage(
        channelId: params.channelId,
        conversationId: params.conversationId,
        message: params.message,
        storageItems: params.storageItems,
        messageType: params.messageType);
  }
}

class SendMessageParams extends Equatable {
  final String message;
  final String messageType;
  final String conversationId;
  final String channelId;
  final List<String>? storageItems;

  const SendMessageParams(
      {required this.message,
      required this.messageType,
      required this.conversationId,
      this.storageItems,
      required this.channelId});

  @override
  List<Object?> get props =>
      [message, messageType, channelId, conversationId, storageItems];
}

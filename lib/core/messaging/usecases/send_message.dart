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
        senderId: params.senderId,
        messageType: params.messageType);
  }
}

class SendMessageParams extends Equatable {
  final String message;
  final String senderId;
  final String messageType;
  final String conversationId;
  final String channelId;

  const SendMessageParams(
      {required this.message,
      required this.senderId,
      required this.messageType,
      required this.conversationId,
      required this.channelId});

  @override
  List<Object?> get props =>
      [message, senderId, messageType, channelId, conversationId];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class InviteHumanToJoin
    extends UseCase<Conversation, ChangeConversationTypeParams> {
  final MessagingRepository messagingRepository;

  InviteHumanToJoin({required this.messagingRepository});

  @override
  Future<Result<Conversation>> call(ChangeConversationTypeParams params) {
    return messagingRepository.changeConversationType(
      channelId: params.channelId,
      userId: params.userId,
      messageType: params.messageType,
      conversationId: params.conversationId,
    );
  }
}

class ChangeConversationTypeParams extends Equatable {
  final String userId;
  final String messageType;
  final String channelId;
  final String conversationId;

  const ChangeConversationTypeParams(
      {required this.userId,
      required this.messageType,
      required this.conversationId,
      required this.channelId});

  @override
  List<Object?> get props => [
        userId,
        conversationId,
        messageType,
        channelId,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class GetConversationDetail
    extends UseCase<Conversation, GetConversationDetailParams> {
  final MessagingRepository messagingRepository;

  GetConversationDetail({required this.messagingRepository});

  @override
  Future<Result<Conversation>> call(GetConversationDetailParams params) {
    return messagingRepository.getConversationDetail(
      channelId: params.channelId,
      userId: params.userId,
      messageType: params.messageType,
      conversationId: params.conversationId,
    );
  }
}

class GetConversationDetailParams extends Equatable {
  final String userId;
  final String messageType;
  final String channelId;
  final String conversationId;

  const GetConversationDetailParams(
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

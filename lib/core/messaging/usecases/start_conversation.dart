import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class StartConversation extends UseCase<Conversation, StartConversationParams> {
  final MessagingRepository messagingRepository;

  StartConversation({required this.messagingRepository});

  @override
  Future<Result<Conversation>> call(StartConversationParams params) {
    return messagingRepository.startConversation(
      channelId: params.channelId,
      userId: params.userId,
      messageType: params.messageType,
      name: params.name,
    );
  }
}

class StartConversationParams extends Equatable {
  final String userId;
  final String messageType;
  final String channelId;
  final String name;

  const StartConversationParams(
      {required this.userId,
      required this.messageType,
      required this.name,
      required this.channelId});

  @override
  List<Object?> get props => [
        userId,
        name,
        messageType,
        channelId,
      ];
}

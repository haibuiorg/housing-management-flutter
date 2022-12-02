import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class GetConversationList
    extends UseCaseStream<List<Conversation>, GetConversationMessageParams> {
  final MessagingRepository messagingRepository;

  GetConversationList({required this.messagingRepository});

  @override
  Stream<List<Conversation>> call(GetConversationMessageParams params) {
    return messagingRepository.getConversationLists(
      messageType: params.messageType,
      userId: params.userId,
    );
  }
}

class GetConversationMessageParams extends Equatable {
  final String messageType;
  final String userId;

  const GetConversationMessageParams(
      {required this.messageType, required this.userId});

  @override
  List<Object?> get props => [userId, messageType];
}

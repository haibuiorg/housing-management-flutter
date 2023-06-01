import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/message.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class GetSupportMessages
    extends UseCaseStream<List<Message>, GetSupportMessageParams> {
  final MessagingRepository messagingRepository;

  GetSupportMessages({required this.messagingRepository});

  @override
  Stream<List<Message>> call(GetSupportMessageParams params) {
    return messagingRepository.getSupportMessages(
      supportChannelId: params.supportChannelId,
      conversationId: params.conversationId,
      isAdminChat: params.isAdminChat,
    );
  }
}

class GetSupportMessageParams extends Equatable {
  final String supportChannelId;
  final String conversationId;
  final bool isAdminChat;

  const GetSupportMessageParams({
    required this.supportChannelId,
    required this.conversationId,
    this.isAdminChat = false,
  });

  @override
  List<Object?> get props => [supportChannelId, conversationId, isAdminChat];
}

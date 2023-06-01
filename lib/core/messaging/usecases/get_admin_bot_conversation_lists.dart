import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class GetAdminBotConversationList
    extends UseCaseStream<List<Conversation>, GetAdminBotConversationParams> {
  final MessagingRepository messagingRepository;

  GetAdminBotConversationList({required this.messagingRepository});

  @override
  Stream<List<Conversation>> call(GetAdminBotConversationParams params) {
    return messagingRepository.getAdminBotConversationLists(
      userId: params.userId,
    );
  }
}

class GetAdminBotConversationParams extends Equatable {
  final String userId;

  const GetAdminBotConversationParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

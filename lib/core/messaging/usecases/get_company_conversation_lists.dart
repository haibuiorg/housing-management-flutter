import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class GetCompanyConversationList
    extends UseCaseStream<List<Conversation>, GetCompanyConversationParams> {
  final MessagingRepository messagingRepository;

  GetCompanyConversationList({required this.messagingRepository});

  @override
  Stream<List<Conversation>> call(GetCompanyConversationParams params) {
    return messagingRepository.getCompanyConversationLists(
      companyId: params.companyId,
      userId: params.userId,
    );
  }
}

class GetCompanyConversationParams extends Equatable {
  final String companyId;
  final String userId;

  const GetCompanyConversationParams(
      {required this.companyId, required this.userId});

  @override
  List<Object?> get props => [companyId, userId];
}

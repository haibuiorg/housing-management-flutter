import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/message.dart';
import 'package:priorli/core/messaging/repos/messaging_repository.dart';

class GetCommunityMessages
    extends UseCaseStream<List<Message>, GetCommunityMessageParams> {
  final MessagingRepository messagingRepository;

  GetCommunityMessages({required this.messagingRepository});

  @override
  Stream<List<Message>> call(GetCommunityMessageParams params) {
    return messagingRepository.getCommunityMessages(
      companyId: params.companyId,
      conversationId: params.conversationId,
    );
  }
}

class GetCommunityMessageParams extends Equatable {
  final String conversationId;
  final String companyId;

  const GetCommunityMessageParams(
      {required this.conversationId, required this.companyId});

  @override
  List<Object?> get props => [companyId, conversationId];
}

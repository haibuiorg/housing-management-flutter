import 'package:equatable/equatable.dart';
import 'package:priorli/core/messaging/models/conversation_model.dart';

import '../../utils/constants.dart';

class Conversation extends Equatable {
  final String id;
  final String status;
  final String channelId;
  final List<String> userIds;
  final String name;
  final String type;
  final bool seen;
  final bool joined;

  const Conversation(
      {required this.id,
      required this.name,
      required this.status,
      required this.channelId,
      required this.type,
      required this.seen,
      required this.joined,
      required this.userIds});

  @override
  List<Object?> get props =>
      [id, status, name, channelId, userIds, type, joined];

  factory Conversation.modelToEntity(
          {required ConversationModel conversationModel, String userId = ''}) =>
      Conversation(
          type: conversationModel.type ?? messageTypeSupport,
          id: conversationModel.id ?? '',
          name: conversationModel.name ?? '',
          status: conversationModel.status ?? '',
          channelId: conversationModel.channel_id ?? '',
          seen: conversationModel.last_message_not_seen_by == null ||
              conversationModel.last_message_not_seen_by?.contains(userId) ==
                  false,
          joined: conversationModel.user_ids != null &&
              conversationModel.user_ids?.contains(userId) == true,
          userIds: conversationModel.user_ids ?? []);
}

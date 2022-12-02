import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/usecases/get_community_messages.dart';
import 'package:priorli/core/messaging/usecases/get_conversation_detail.dart';
import 'package:priorli/core/messaging/usecases/get_support_messages.dart';
import 'package:priorli/core/messaging/usecases/join_conversation.dart';
import 'package:priorli/core/messaging/usecases/send_message.dart';
import 'package:priorli/core/messaging/usecases/set_conversation_seen.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';
import 'package:priorli/presentation/message/message_state.dart';

import '../../core/messaging/entities/message.dart';
import '../../core/utils/constants.dart';

class MessageCubit extends Cubit<MessageState> {
  final GetCommunityMessages _getCommunityMessages;
  final GetSupportMessages _getSupportMessages;
  final SendMessage _sendMessage;
  final GetUserInfo _getUserInfo;
  final GetConversationDetail _getConversationDetail;
  final JoinConversation _joinConversation;
  final SetConversationSeen _setConversationSeen;
  StreamSubscription? _myMessageSubscription;

  MessageCubit(
      this._getCommunityMessages,
      this._getUserInfo,
      this._getSupportMessages,
      this._sendMessage,
      this._getConversationDetail,
      this._joinConversation,
      this._setConversationSeen)
      : super(const MessageState());

  Future<void> init(
      {required String channelId,
      required String conversationId,
      required String messageType}) async {
    final getUserInfoResult = await _getUserInfo(NoParams());
    MessageState pendingState = state.copyWith(messageType: messageType);
    if (getUserInfoResult is ResultSuccess<User>) {
      pendingState = pendingState.copyWith(user: getUserInfoResult.data);
    }
    final conversationResult = await _getConversationDetail(
        GetConversationDetailParams(
            userId: pendingState.user?.userId ?? '',
            messageType: messageType,
            conversationId: conversationId,
            channelId: channelId));
    if (conversationResult is ResultSuccess<Conversation>) {
      pendingState =
          pendingState.copyWith(conversation: conversationResult.data);
    }
    _myMessageSubscription?.cancel();
    if (messageType == messageTypeCommunity) {
      _myMessageSubscription = _getCommunityMessages(GetCommunityMessageParams(
              conversationId: conversationId, companyId: channelId))
          .listen(_messageListener);
    } else if (messageType == messageTypeSupport) {
      _myMessageSubscription = _getSupportMessages(GetSupportMessageParams(
              supportChannelId: channelId, conversationId: conversationId))
          .listen(_messageListener);
    }
    emit(pendingState);
    await setConversationSeen();
  }

  Future<void> sendMessage(String message) async {
    await _sendMessage(SendMessageParams(
        message: message,
        senderId: state.user?.userId ?? '',
        messageType: state.messageType ?? messageTypeSupport,
        channelId: state.conversation?.channelId ?? '',
        conversationId: state.conversation?.id ?? ''));
  }

  _messageListener(List<Message> messageList) {
    final List<Message> newList = List.from(state.messageList ?? []);
    final idList = messageList.map((e) => e.id);
    newList.removeWhere(
      (element) {
        return idList.contains(element.id);
      },
    );
    newList.addAll(messageList);
    newList.sort(
      (a, b) => b.createdOn - a.createdOn,
    );
    emit(state.copyWith(messageList: newList));
  }

  @override
  Future<void> close() {
    _myMessageSubscription?.cancel();
    return super.close();
  }

  Future<void> joinConversation() async {
    final conversationResult = await _joinConversation(JoinConversationParams(
        userId: state.user?.userId ?? '',
        messageType: state.messageType ?? '',
        conversationId: state.conversation?.id ?? '',
        channelId: state.conversation?.channelId ?? ''));
    if (conversationResult is ResultSuccess<Conversation>) {
      emit(state.copyWith(conversation: conversationResult.data));
    }
  }

  Future<void> setConversationSeen() async {
    final conversationResult = await _setConversationSeen(
        SetConversationSeenParams(
            userId: state.user?.userId ?? '',
            messageType: state.messageType ?? '',
            conversationId: state.conversation?.id ?? '',
            channelId: state.conversation?.channelId ?? ''));
    if (conversationResult is ResultSuccess<Conversation>) {
      emit(state.copyWith(conversation: conversationResult.data));
    }
  }
}

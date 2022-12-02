import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/messaging/usecases/get_conversation_lists.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';
import 'package:priorli/core/utils/constants.dart';

import '../../core/base/result.dart';
import '../../core/base/usecase.dart';
import 'conversation_list_state.dart';

class ConversationListCubit extends Cubit<ConversationListState> {
  final GetConversationList _getConversationList;
  final GetUserInfo _getUserInfo;
  StreamSubscription? _conversationSubscription;

  ConversationListCubit(
    this._getConversationList,
    this._getUserInfo,
  ) : super(const ConversationListState()) {
    init();
  }

  Future<void> init() async {
    final getUserInfoResult = await _getUserInfo(NoParams());
    if (getUserInfoResult is ResultSuccess<User>) {
      _conversationSubscription?.cancel();
      _conversationSubscription = _getConversationList(
              GetConversationMessageParams(
                  messageType: messageTypeCommunity,
                  userId: getUserInfoResult.data.userId))
          .listen(_messageListener);
    }
  }

  _messageListener(List<Conversation> conversationList) {
    emit(state.copyWith(conversationList: conversationList));
  }

  @override
  Future<void> close() {
    _conversationSubscription?.cancel();
    return super.close();
  }
}

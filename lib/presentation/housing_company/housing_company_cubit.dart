import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/core/announcement/usecases/get_announcement_list.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartments.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/messaging/usecases/get_company_conversation_lists.dart';
import 'package:priorli/core/messaging/usecases/start_conversation.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';
import 'package:priorli/core/utils/constants.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/usecases/get_yearly_water_consumption.dart';
import 'package:priorli/presentation/housing_company/housing_company_state.dart';

import '../../core/messaging/entities/conversation.dart';

class HousingCompanyCubit extends Cubit<HousingCompanyState> {
  final GetApartments _getApartments;
  final GetHousingCompany _getHousingCompany;
  final GetYearlyWaterConsumption _getYearlyWaterConsumption;
  final GetAnnouncementList _getAnnouncementList;
  final GetCompanyConversationList _getCompanyConversationList;
  final StartConversation _startConversation;
  final GetUserInfo _getUserInfo;
  StreamSubscription? _conversationSubscription;
  HousingCompanyCubit(
      this._getApartments,
      this._getHousingCompany,
      this._getYearlyWaterConsumption,
      this._getAnnouncementList,
      this._getCompanyConversationList,
      this._startConversation,
      this._getUserInfo)
      : super(const HousingCompanyState());

  Future<void> init(String housingCompanyId) async {
    final companyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    final userInfoResult = await _getUserInfo(NoParams());
    HousingCompanyState pendingState = state.copyWith();
    if (companyResult is ResultSuccess<HousingCompany>) {
      pendingState =
          (pendingState.copyWith(housingCompany: companyResult.data));
    }
    if (userInfoResult is ResultSuccess<User>) {
      pendingState = pendingState.copyWith(user: userInfoResult.data);
    }
    final apartResult = await _getApartments(
        GetApartmentParams(housingCompanyId: housingCompanyId));
    if (apartResult is ResultSuccess<List<Apartment>>) {
      pendingState = (pendingState.copyWith(apartmentList: apartResult.data));
    }
    final waterConsumptionResult = await _getYearlyWaterConsumption(
        GetYearlyWaterConsumptionParams(
            housingCompanyId: housingCompanyId, year: 2022));
    if (waterConsumptionResult is ResultSuccess<List<WaterConsumption>>) {
      pendingState = (pendingState.copyWith(
          yearlyWaterConsumption: waterConsumptionResult.data));
    }
    final announcementListResult = await _getAnnouncementList(
        GetAnnouncementListParams(
            housingCompanyId: housingCompanyId,
            lastAnnouncementTime: DateTime.now().millisecondsSinceEpoch,
            total: 2));
    if (announcementListResult is ResultSuccess<List<Announcement>>) {
      pendingState = (pendingState.copyWith(
          announcementList: announcementListResult.data));
    }
    emit(pendingState);
    _conversationSubscription?.cancel();
    _conversationSubscription = _getCompanyConversationList(
            GetCompanyConversationParams(
                companyId: housingCompanyId, userId: ''))
        .listen(_messageListener);
  }

  _messageListener(List<Conversation> conversationList) {
    emit(state.copyWith(conversationList: conversationList));
  }

  Future<void> startNewChannel(String name) async {
    await _startConversation(StartConversationParams(
        userId: state.user?.userId ?? '',
        messageType: messageTypeCommunity,
        name: name,
        channelId: state.housingCompany?.id ?? ''));
  }

  @override
  Future<void> close() {
    _conversationSubscription?.cancel();
    return super.close();
  }
}

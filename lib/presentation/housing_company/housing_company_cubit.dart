import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/core/announcement/usecases/get_announcement_list.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/apartment/usecases/get_apartments.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/event/entities/event.dart';
import 'package:priorli/core/event/entities/event_type.dart';
import 'package:priorli/core/event/usecases/get_event_list.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_company_document.dart';
import 'package:priorli/core/housing/usecases/get_company_document_list.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/invoice/entities/invoice_group.dart';
import 'package:priorli/core/invoice/usecases/get_invoice_groups.dart';
import 'package:priorli/core/messaging/usecases/get_company_conversation_lists.dart';
import 'package:priorli/core/messaging/usecases/start_conversation.dart';
import 'package:priorli/core/poll/usecases/get_poll_list.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';
import 'package:priorli/core/user/entities/user.dart';
import 'package:priorli/core/user/usecases/get_user_info.dart';
import 'package:priorli/core/utils/constants.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/core/water_usage/usecases/get_yearly_water_consumption.dart';
import 'package:priorli/presentation/housing_company/housing_company_state.dart';

import '../../core/messaging/entities/conversation.dart';
import '../../core/poll/entities/poll.dart';

class HousingCompanyCubit extends Cubit<HousingCompanyState> {
  final GetApartments _getApartments;
  final GetHousingCompany _getHousingCompany;
  final GetYearlyWaterConsumption _getYearlyWaterConsumption;
  final GetAnnouncementList _getAnnouncementList;
  final GetCompanyConversationList _getCompanyConversationList;
  final StartConversation _startConversation;
  final GetCompanyDocumentList _getCompanyDocumentList;
  final GetUserInfo _getUserInfo;
  final GetCompanyDocument _getCompanyDocument;
  final GetEventList _getEventList;
  final GetPollList _getPollList;
  final GetInvoiceGroups _getInvoiceGroups;

  StreamSubscription? _conversationSubscription;
  HousingCompanyCubit(
      this._getInvoiceGroups,
      this._getApartments,
      this._getHousingCompany,
      this._getYearlyWaterConsumption,
      this._getAnnouncementList,
      this._getCompanyConversationList,
      this._startConversation,
      this._getCompanyDocumentList,
      this._getCompanyDocument,
      this._getUserInfo,
      this._getEventList,
      this._getPollList)
      : super(const HousingCompanyState());

  Future<void> init(String housingCompanyId) async {
    getUserData();
    final company = await getHousingCompanyData(housingCompanyId);

    getCompanyInvoiceGroup(
        housingCompanyId: housingCompanyId,
        isManager: company?.isUserManager == true);
    getAparmentList(housingCompanyId);
    getWaterConsumptionData(housingCompanyId);
    getAnnouncementListData(housingCompanyId);
    getCompanyDocumentData(
        housingCompanyId: housingCompanyId,
        isManager: company?.isUserManager == true);
    getOnGoingEventData(
        housingCompanyId: housingCompanyId,
        isManager: company?.isUserManager == true);
    getOnGoingPoll(
        housingCompanyId: housingCompanyId,
        isManager: company?.isUserManager == true);
    _conversationSubscription?.cancel();
    _conversationSubscription = _getCompanyConversationList(
            GetCompanyConversationParams(
                companyId: housingCompanyId, userId: ''))
        .listen(_messageListener);
  }

  Future<HousingCompany?> getHousingCompanyData(String housingCompanyId) async {
    final companyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: housingCompanyId));
    if (companyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(housingCompany: companyResult.data));
      return companyResult.data;
    }
    emit(state.copyWith(housingCompany: null));
    return null;
  }

  Future<User?> getUserData() async {
    final userInfoResult = await _getUserInfo(NoParams());
    if (userInfoResult is ResultSuccess<User>) {
      emit(state.copyWith(user: userInfoResult.data));
      return userInfoResult.data;
    }
    emit(state.copyWith(user: null));
    return null;
  }

  Future<List<Apartment>> getAparmentList(String housingCompanyId) async {
    final apartResult = await _getApartments(
        GetApartmentParams(housingCompanyId: housingCompanyId));
    if (apartResult is ResultSuccess<List<Apartment>>) {
      emit(state.copyWith(apartmentList: apartResult.data));
      return apartResult.data;
    }
    emit(state.copyWith(apartmentList: []));
    return [];
  }

  Future<List<InvoiceGroup>> getCompanyInvoiceGroup(
      {required String housingCompanyId, bool isManager = false}) async {
    final invoiceGroupResult = await _getInvoiceGroups(
        GetInvoiceGroupParams(companyId: housingCompanyId));
    if (invoiceGroupResult is ResultSuccess<List<InvoiceGroup>>) {
      emit(state.copyWith(invoiceGroupList: invoiceGroupResult.data));
      return invoiceGroupResult.data;
    }
    emit(state.copyWith(invoiceGroupList: []));
    return [];
  }

  Future<List<WaterConsumption>> getWaterConsumptionData(
      String housingCompanyId) async {
    final waterConsumptionResult = await _getYearlyWaterConsumption(
        GetYearlyWaterConsumptionParams(
            housingCompanyId: housingCompanyId, year: DateTime.now().year));
    if (waterConsumptionResult is ResultSuccess<List<WaterConsumption>>) {
      emit(state.copyWith(yearlyWaterConsumption: waterConsumptionResult.data));
      return waterConsumptionResult.data;
    }
    emit(state.copyWith(yearlyWaterConsumption: []));
    return [];
  }

  Future<List<Announcement>> getAnnouncementListData(
      String housingCompanyId) async {
    final announcementListResult = await _getAnnouncementList(
        GetAnnouncementListParams(
            housingCompanyId: housingCompanyId,
            lastAnnouncementTime: DateTime.now().millisecondsSinceEpoch,
            total: 2));
    if (announcementListResult is ResultSuccess<List<Announcement>>) {
      emit(state.copyWith(announcementList: announcementListResult.data));
      return announcementListResult.data;
    }
    emit(state.copyWith(announcementList: []));
    return [];
  }

  Future<List<StorageItem>> getCompanyDocumentData(
      {required String housingCompanyId, bool isManager = false}) async {
    final housingCompanyDocumentResult = await _getCompanyDocumentList(
        GetCompanyDocumentListParams(housingCompanyId: housingCompanyId));
    if (housingCompanyDocumentResult is ResultSuccess<List<StorageItem>>) {
      emit(state.copyWith(documentList: housingCompanyDocumentResult.data));
      return housingCompanyDocumentResult.data;
    }
    emit(state.copyWith(documentList: []));
    return [];
  }

  Future<List<Event>> getOnGoingEventData(
      {required String housingCompanyId, bool isManager = false}) async {
    final ongoingEventListResult = await _getEventList(GetEventListParams(
        includePastEvent: false,
        limit: 5,
        companyId: housingCompanyId,
        types: const [EventType.company, EventType.companyInternal]));
    if (ongoingEventListResult is ResultSuccess<List<Event>>) {
      emit(state.copyWith(ongoingEventList: ongoingEventListResult.data));
      return ongoingEventListResult.data;
    }
    emit(state.copyWith(ongoingEventList: []));
    return [];
  }

  Future<List<Poll>> getOnGoingPoll(
      {required String housingCompanyId, bool isManager = false}) async {
    final ongoingPollListResult = await _getPollList(GetPollListParams(
        includeEndedPoll: false, limit: 5, companyId: housingCompanyId));
    if (ongoingPollListResult is ResultSuccess<List<Poll>>) {
      final newState =
          (state.copyWith(ongoingPollList: ongoingPollListResult.data));
      emit(newState);
      return ongoingPollListResult.data;
    }
    emit(state.copyWith(ongoingPollList: []));
    return [];
  }

  _messageListener(List<Conversation> conversationList) {
    emit(state.copyWith(
        faultReportList: conversationList
            .where((element) => element.type == messageTypeFaultReport)
            .toList(),
        conversationList: conversationList
            .where((element) => element.type == messageTypeCommunity)
            .toList()));
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

  Future<StorageItem?> getDocument(String id) async {
    final getCompanyDocumentResult = await _getCompanyDocument(
        GetCompanyDocumentParams(
            housingCompanyId: state.housingCompany?.id ?? '', documentId: id));
    if (getCompanyDocumentResult is ResultSuccess<StorageItem>) {
      return getCompanyDocumentResult.data;
    }
    return null;
  }

  Future<void> refresh() async {}
}

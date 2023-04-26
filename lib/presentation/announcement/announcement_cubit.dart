import 'package:bloc/bloc.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/core/announcement/usecases/get_announcement_list.dart';
import 'package:priorli/core/announcement/usecases/make_annoucement.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';

import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final GetAnnouncementList _getAnnouncementList;
  final MakeAnnouncement _makeAnnouncement;
  final GetHousingCompany _getHousingCompany;
  AnnouncementCubit(
    this._getAnnouncementList,
    this._makeAnnouncement,
    this._getHousingCompany,
  ) : super(const AnnouncementState());

  Future<void> init(String housingCompanyId) async {
    emit(state.copyWith(isLoading: true));
    final getAnnouncementListResult = await _getAnnouncementList(
        GetAnnouncementListParams(
            housingCompanyId: housingCompanyId,
            lastAnnouncementTime: DateTime.now().millisecondsSinceEpoch,
            total: state.total ?? 10));
    emit(state.copyWith(isLoading: false));
    if (getAnnouncementListResult is ResultSuccess<List<Announcement>>) {
      emit(state.copyWith(
          announcementList: getAnnouncementListResult.data,
          housingCompanyId: housingCompanyId));
    } else {
      emit(state.copyWith(housingCompanyId: housingCompanyId));
    }
    getHousingCompanyData(housingCompanyId);
  }

  Future<void> getHousingCompanyData(String housingCompanyId) async {
    emit(state.copyWith(isLoading: true));
    final getHousingCompanyResult =
        await _getHousingCompany(GetHousingCompanyParams(
      housingCompanyId: housingCompanyId,
    ));
    emit(state.copyWith(isLoading: false));
    if (getHousingCompanyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(
          isManager: getHousingCompanyResult.data.isUserManager == true));
    } else {
      emit(state.copyWith(
          housingCompanyId: housingCompanyId,
          announcementList: [],
          isManager: false));
    }
  }

  Future<void> addAnnouncement(
      {required String title,
      required String subtitle,
      List<String>? storageItems,
      required bool sendEmail,
      required String body}) async {
    emit(state.copyWith(isLoading: true));
    final makeAnnouncementResult = await _makeAnnouncement(
        MakeAnnouncementParams(
            sendEmail: sendEmail,
            storageItems: storageItems,
            housingCompanyId: state.housingCompanyId ?? '',
            title: title,
            subtitle: subtitle,
            body: body));
    emit(state.copyWith(isLoading: false));
    if (makeAnnouncementResult is ResultSuccess<Announcement>) {
      final List<Announcement> currentList =
          List.from(state.announcementList ?? []);
      currentList.insert(0, makeAnnouncementResult.data);
      emit(state.copyWith(announcementList: currentList));
    } else {
      emit(state.copyWith(error: 'Error making announcement'));
    }
  }

  Future<void> loadMore() async {
    emit(state.copyWith(isLoading: true));
    final getAnnouncementListResult = await _getAnnouncementList(
        GetAnnouncementListParams(
            housingCompanyId: state.housingCompanyId ?? '',
            lastAnnouncementTime: state.announcementList?.last.createdOn ??
                DateTime.now().millisecondsSinceEpoch,
            total: state.total ?? 10));
    emit(state.copyWith(isLoading: false));
    if (getAnnouncementListResult is ResultSuccess<List<Announcement>>) {
      final List<Announcement> currentList =
          List.from(state.announcementList ?? []);
      currentList.addAll(getAnnouncementListResult.data);
      emit(state.copyWith(
        announcementList: currentList,
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}

import 'package:bloc/bloc.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/core/announcement/usecases/edit_announcement.dart';
import 'package:priorli/core/announcement/usecases/get_announcement.dart';
import 'package:priorli/core/announcement/usecases/get_announcement_list.dart';
import 'package:priorli/core/announcement/usecases/make_annoucement.dart';
import 'package:priorli/core/base/result.dart';

import 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final GetAnnouncementList _getAnnouncementList;
  final GetAnnouncement _getAnnouncement;
  final MakeAnnouncement _makeAnnouncement;
  final EditAnnouncement _editAnnouncement;
  AnnouncementCubit(this._getAnnouncementList, this._getAnnouncement,
      this._makeAnnouncement, this._editAnnouncement)
      : super(const AnnouncementState());

  Future<void> init(String housingCompanyId) async {
    final getAnnouncementListResult = await _getAnnouncementList(
        GetAnnouncementListParams(
            housingCompanyId: housingCompanyId,
            lastAnnouncementTime: DateTime.now().millisecondsSinceEpoch,
            total: state.total ?? 10));
    if (getAnnouncementListResult is ResultSuccess<List<Announcement>>) {
      emit(state.copyWith(
          announcementList: getAnnouncementListResult.data,
          housingCompanyId: housingCompanyId));
    } else {
      emit(state.copyWith(housingCompanyId: housingCompanyId));
    }
  }

  Future<void> addAnnouncement(
      {required String title,
      required String subtitle,
      required String body}) async {
    final makeAnnouncementResult = await _makeAnnouncement(
        MakeAnnouncementParams(
            housingCompanyId: state.housingCompanyId ?? '',
            title: title,
            subtitle: subtitle,
            body: body));
    if (makeAnnouncementResult is ResultSuccess<Announcement>) {
      final List<Announcement> currentList =
          List.from(state.announcementList ?? []);
      currentList.insert(0, makeAnnouncementResult.data);
      emit(state.copyWith(announcementList: currentList));
    }
  }

  Future<void> loadMore() async {
    final getAnnouncementListResult = await _getAnnouncementList(
        GetAnnouncementListParams(
            housingCompanyId: state.housingCompanyId ?? '',
            lastAnnouncementTime: state.announcementList?.last.createdOn ??
                DateTime.now().millisecondsSinceEpoch,
            total: state.total ?? 10));
    if (getAnnouncementListResult is ResultSuccess<List<Announcement>>) {
      final List<Announcement> currentList =
          List.from(state.announcementList ?? []);
      currentList.addAll(getAnnouncementListResult.data);
      emit(state.copyWith(
        announcementList: currentList,
      ));
    }
  }
}

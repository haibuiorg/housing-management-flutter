import 'package:bloc/bloc.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/core/announcement/usecases/edit_announcement.dart';
import 'package:priorli/core/announcement/usecases/get_announcement.dart';
import 'package:priorli/core/base/result.dart';

import 'announcement_item_state.dart';

class AnnouncementItemCubit extends Cubit<AnnouncementItemState> {
  final GetAnnouncement _getAnnouncement;
  final EditAnnouncement _editAnnouncement;
  AnnouncementItemCubit(this._getAnnouncement, this._editAnnouncement)
      : super(const AnnouncementItemState());

  init(String housingCompanyId, Announcement announcement) async {
    emit(state.copyWith(
        housingCompanyId: housingCompanyId, announcement: announcement));
  }

  Future<Announcement?> getAnnouncementDetail() async {
    final getAnnouncementDetailResult = await _getAnnouncement(
        GetAnnouncementParams(
            housingCompanyId: state.housingCompanyId ?? '',
            announcementId: state.announcement?.id ?? ''));
    if (getAnnouncementDetailResult is ResultSuccess<Announcement>) {
      emit(state.copyWith(announcement: getAnnouncementDetailResult.data));
      return state.announcement;
    }
    return null;
  }
}

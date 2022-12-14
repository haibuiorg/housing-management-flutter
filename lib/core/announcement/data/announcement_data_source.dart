import 'package:priorli/core/announcement/models/announcement_model.dart';

abstract class AnnouncementDataSource {
  Future<AnnouncementModel> editAnnouncement({
    required String housingCompanyId,
    required String announcementId,
    String? title,
    String? subtitle,
    String? body,
    bool? isDeleted,
  });
  Future<List<AnnouncementModel>> getAnnouncementList(
      {required String housingCompanyId,
      required int total,
      required int lastAnnouncementTime});
  Future<AnnouncementModel> getAnnouncement({
    required String housingCompanyId,
    required String announcementId,
  });
  Future<AnnouncementModel> makeAnnouncement(
      {required String housingCompanyId,
      required String title,
      String? subtitle,
      List<String>? storageItems,
      required bool sendEmail,
      required String body});
}

import '../../base/result.dart';
import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<Result<Announcement>> editAnnouncement({
    required String housingCompanyId,
    required String announcementId,
    String? title,
    String? subtitle,
    String? body,
    bool? isDeleted,
  });
  Future<Result<List<Announcement>>> getAnnouncementList(
      {required String housingCompanyId,
      required int total,
      required int lastAnnouncementTime});
  Future<Result<Announcement>> getAnnouncement({
    required String housingCompanyId,
    required String announcementId,
  });
  Future<Result<Announcement>> makeAnnouncement(
      {required String housingCompanyId,
      required String title,
      String? subtitle,
      required String body});
}

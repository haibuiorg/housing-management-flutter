import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/announcement.dart';
import '../repos/announcement_repository.dart';

class EditAnnouncement extends UseCase<Announcement, EditAnnouncementParams> {
  final AnnouncementRepository announcementRepository;

  EditAnnouncement({required this.announcementRepository});
  @override
  Future<Result<Announcement>> call(EditAnnouncementParams params) {
    return announcementRepository.editAnnouncement(
        housingCompanyId: params.housingCompanyId,
        title: params.title,
        subtitle: params.subtitle,
        body: params.body,
        isDeleted: params.isDeleted,
        announcementId: params.announcementId);
  }
}

class EditAnnouncementParams extends Equatable {
  final String housingCompanyId;
  final String announcementId;
  final String? title;
  final String? subtitle;
  final String? body;
  final bool? isDeleted;

  const EditAnnouncementParams(
      {required this.housingCompanyId,
      required this.announcementId,
      this.title,
      this.subtitle,
      this.body,
      this.isDeleted});

  @override
  List<Object?> get props =>
      [housingCompanyId, announcementId, title, subtitle, body, isDeleted];
}

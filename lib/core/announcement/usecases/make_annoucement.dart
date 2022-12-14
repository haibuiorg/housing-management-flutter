import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/announcement.dart';
import '../repos/announcement_repository.dart';

class MakeAnnouncement extends UseCase<Announcement, MakeAnnouncementParams> {
  final AnnouncementRepository announcementRepository;

  MakeAnnouncement({required this.announcementRepository});
  @override
  Future<Result<Announcement>> call(MakeAnnouncementParams params) {
    return announcementRepository.makeAnnouncement(
        housingCompanyId: params.housingCompanyId,
        title: params.title,
        sendEmail: params.sendEmail,
        storageItems: params.storageItems,
        body: params.body,
        subtitle: params.subtitle);
  }
}

class MakeAnnouncementParams extends Equatable {
  final String housingCompanyId;
  final String title;
  final String? subtitle;
  final String body;
  final List<String>? storageItems;
  final bool sendEmail;

  const MakeAnnouncementParams(
      {required this.housingCompanyId,
      required this.title,
      required this.sendEmail,
      this.subtitle,
      this.storageItems,
      required this.body});

  @override
  List<Object?> get props =>
      [housingCompanyId, title, subtitle, body, storageItems, sendEmail];
}

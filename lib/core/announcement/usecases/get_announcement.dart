import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/announcement.dart';
import '../repos/announcement_repository.dart';

class GetAnnouncement extends UseCase<Announcement, GetAnnouncementParams> {
  final AnnouncementRepository announcementRepository;

  GetAnnouncement({required this.announcementRepository});
  @override
  Future<Result<Announcement>> call(GetAnnouncementParams params) {
    return announcementRepository.getAnnouncement(
        housingCompanyId: params.housingCompanyId,
        announcementId: params.announcementId);
  }
}

class GetAnnouncementParams extends Equatable {
  final String housingCompanyId;
  final String announcementId;

  const GetAnnouncementParams({
    required this.housingCompanyId,
    required this.announcementId,
  });

  @override
  List<Object?> get props => [
        housingCompanyId,
        announcementId,
      ];
}

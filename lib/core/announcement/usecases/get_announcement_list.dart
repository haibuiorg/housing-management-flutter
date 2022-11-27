import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/announcement.dart';
import '../repos/announcement_repository.dart';

class GetAnnouncementList
    extends UseCase<List<Announcement>, GetAnnouncementListParams> {
  final AnnouncementRepository announcementRepository;

  GetAnnouncementList({required this.announcementRepository});
  @override
  Future<Result<List<Announcement>>> call(GetAnnouncementListParams params) {
    return announcementRepository.getAnnouncementList(
        housingCompanyId: params.housingCompanyId,
        total: params.total,
        lastAnnouncementTime: params.lastAnnouncementTime);
  }
}

class GetAnnouncementListParams extends Equatable {
  final String housingCompanyId;
  final int total;
  final int lastAnnouncementTime;

  const GetAnnouncementListParams(
      {required this.housingCompanyId,
      required this.lastAnnouncementTime,
      required this.total});

  @override
  List<Object?> get props => [housingCompanyId, lastAnnouncementTime, total];
}

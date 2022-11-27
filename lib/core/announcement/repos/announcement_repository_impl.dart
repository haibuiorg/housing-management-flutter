import 'package:priorli/core/announcement/data/announcement_data_source.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/core/announcement/repos/announcement_repository.dart';
import 'package:priorli/core/base/result.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementDataSource announcementDataSource;

  AnnouncementRepositoryImpl({required this.announcementDataSource});

  @override
  Future<Result<Announcement>> editAnnouncement(
      {required String housingCompanyId,
      required String announcementId,
      String? title,
      String? subtitle,
      String? body,
      bool? isDeleted}) async {
    try {
      final announcementModel = await announcementDataSource.editAnnouncement(
          housingCompanyId: housingCompanyId,
          announcementId: announcementId,
          subtitle: subtitle,
          body: body,
          isDeleted: isDeleted,
          title: title);
      return ResultSuccess(Announcement.modelToEntity(announcementModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Announcement>> getAnnouncement(
      {required String housingCompanyId,
      required String announcementId}) async {
    try {
      final announcementModel = await announcementDataSource.getAnnouncement(
        housingCompanyId: housingCompanyId,
        announcementId: announcementId,
      );
      return ResultSuccess(Announcement.modelToEntity(announcementModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<Announcement>>> getAnnouncementList(
      {required String housingCompanyId,
      required int total,
      required int lastAnnouncementTime}) async {
    try {
      final announcementModelList =
          await announcementDataSource.getAnnouncementList(
        housingCompanyId: housingCompanyId,
        total: total,
        lastAnnouncementTime: lastAnnouncementTime,
      );
      return ResultSuccess(announcementModelList
          .map((e) => Announcement.modelToEntity(e))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Announcement>> makeAnnouncement(
      {required String housingCompanyId,
      required String title,
      String? subtitle,
      required String body}) async {
    try {
      final announcementModel = await announcementDataSource.makeAnnouncement(
          housingCompanyId: housingCompanyId,
          title: title,
          subtitle: subtitle,
          body: body);
      return ResultSuccess(Announcement.modelToEntity(announcementModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

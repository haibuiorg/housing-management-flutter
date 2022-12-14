import 'package:dio/dio.dart';
import 'package:priorli/core/announcement/data/announcement_data_source.dart';
import 'package:priorli/core/announcement/models/announcement_model.dart';

import '../../base/exceptions.dart';

class AnnouncementRemoteDataSource implements AnnouncementDataSource {
  final Dio client;

  AnnouncementRemoteDataSource({required this.client});

  final _path = '/announcement';

  @override
  Future<AnnouncementModel> editAnnouncement(
      {required String housingCompanyId,
      required String announcementId,
      String? title,
      String? subtitle,
      String? body,
      bool? isDeleted}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "announcement_id": announcementId,
        "title": title,
        "subtitle": subtitle,
        "body": body,
        "is_deleted": isDeleted
      };
      final result = await client.patch(_path, data: data);
      return AnnouncementModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<AnnouncementModel> getAnnouncement(
      {required String housingCompanyId,
      required String announcementId}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
      };
      final result =
          await client.get('$_path/$announcementId', queryParameters: data);
      return AnnouncementModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncementList(
      {required String housingCompanyId,
      required int total,
      required int lastAnnouncementTime}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "total": total,
        "last_announcement_time": lastAnnouncementTime
      };
      final result = await client.get(_path, queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => AnnouncementModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<AnnouncementModel> makeAnnouncement(
      {required String housingCompanyId,
      required String title,
      List<String>? storageItems,
      required bool sendEmail,
      String? subtitle,
      required String body}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "title": title,
        "subtitle": subtitle,
        "body": body,
        'send_email': sendEmail,
        'storage_items': storageItems
      };
      final result = await client.post(_path, data: data);
      return AnnouncementModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

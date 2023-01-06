import 'package:dio/dio.dart';
import 'package:priorli/core/fault_report/data/fault_report_data_source.dart';
import 'package:priorli/core/messaging/models/conversation_model.dart';

import '../../base/exceptions.dart';

class FaultReportRemoteDataSource implements FaultReportDataSource {
  final Dio client;

  FaultReportRemoteDataSource({required this.client});
  @override
  Future<ConversationModel> createFaultReport(
      {required String companyId,
      required String apartmentId,
      required String title,
      required String description,
      bool? sendEmail,
      List<String>? storageItems}) async {
    try {
      final data = {
        'title': title,
        'description': description,
        'storage_items': storageItems,
        'send_email': sendEmail
      };
      final result = await client.post(
          '/housing_company/$companyId/apartment/$apartmentId/fault-report',
          data: data);
      return ConversationModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

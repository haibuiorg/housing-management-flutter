import 'package:priorli/core/messaging/models/conversation_model.dart';

abstract class FaultReportDataSource {
  Future<ConversationModel> createFaultReport(
      {required String companyId,
      required String apartmentId,
      required String title,
      required String description,
      bool? sendEmail,
      List<String>? storageItems});
}

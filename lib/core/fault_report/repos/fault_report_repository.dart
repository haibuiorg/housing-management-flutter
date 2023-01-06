import 'package:priorli/core/messaging/entities/conversation.dart';

import '../../base/result.dart';

abstract class FaultReportRepository {
  Future<Result<Conversation>> createFaultReport(
      {required String companyId,
      required String apartmentId,
      required String title,
      required String description,
      bool? sendEmail,
      List<String>? storageItems});
}

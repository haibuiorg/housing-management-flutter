import 'package:priorli/core/fault_report/data/fault_report_data_source.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';

import 'package:priorli/core/base/result.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';
import 'fault_report_repository.dart';

class FaultReportRepositoryImpl implements FaultReportRepository {
  final FaultReportDataSource faultReportRemoteDataSource;

  FaultReportRepositoryImpl({required this.faultReportRemoteDataSource});

  @override
  Future<Result<Conversation>> createFaultReport(
      {required String companyId,
      required String apartmentId,
      required String title,
      required String description,
      bool? sendEmail,
      List<String>? storageItems}) async {
    try {
      final model = await faultReportRemoteDataSource.createFaultReport(
          companyId: companyId,
          apartmentId: apartmentId,
          title: title,
          sendEmail: sendEmail,
          description: description,
          storageItems: storageItems);
      return ResultSuccess(
          Conversation.modelToEntity(conversationModel: model));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/fault_report/repos/fault_report_repository.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';

class CreateFaultReport extends UseCase<Conversation, CreateFaultReportParams> {
  final FaultReportRepository faultReportRepository;

  CreateFaultReport({required this.faultReportRepository});
  @override
  Future<Result<Conversation>> call(CreateFaultReportParams params) {
    return faultReportRepository.createFaultReport(
        companyId: params.companyId,
        apartmentId: params.apartmentId,
        title: params.title,
        sendEmail: params.sendEmail,
        description: params.description,
        storageItems: params.storageItems);
  }
}

class CreateFaultReportParams extends Equatable {
  final String companyId;
  final String apartmentId;
  final String title;
  final bool? sendEmail;
  final String description;
  final List<String>? storageItems;

  const CreateFaultReportParams(
      {required this.companyId,
      required this.apartmentId,
      required this.title,
      this.sendEmail,
      required this.description,
      this.storageItems});

  @override
  List<Object?> get props =>
      [companyId, apartmentId, title, description, storageItems, sendEmail];
}

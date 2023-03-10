import 'package:priorli/core/base/usecase.dart';

import '../../base/result.dart';
import '../entities/contact_lead.dart';
import '../repos/contact_lead_repo.dart';

class UpdateContactLead extends UseCase<ContactLead, UpdateContactLeadParams> {
  final ContactLeadRepo contactLeadRepo;

  UpdateContactLead({required this.contactLeadRepo});
  @override
  Future<Result<ContactLead>> call(UpdateContactLeadParams params) async {
    final result = await contactLeadRepo.updateContactLeadStatus(
        id: params.id, status: params.status);
    return result;
  }
}

class UpdateContactLeadParams {
  final String id;
  final String status;

  UpdateContactLeadParams({
    required this.id,
    required this.status,
  });
}

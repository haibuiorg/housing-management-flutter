import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/contact_lead.dart';
import '../repos/contact_lead_repo.dart';

class GetContactLeads
    extends UseCase<List<ContactLead>, GetContactLeadListParams> {
  final ContactLeadRepo contactLeadRepo;

  GetContactLeads({required this.contactLeadRepo});
  @override
  Future<Result<List<ContactLead>>> call(
      GetContactLeadListParams params) async {
    final result = await contactLeadRepo.getContactLeads(
        status: params.status, type: params.type);
    return result;
  }
}

class GetContactLeadListParams {
  final String? status;
  final String? type;

  GetContactLeadListParams({
    this.status,
    this.type,
  });
}

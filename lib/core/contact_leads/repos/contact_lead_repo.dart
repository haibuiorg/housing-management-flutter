import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/contact_leads/entities/contact_lead.dart';

abstract class ContactLeadRepo {
  Future<Result<List<ContactLead>>> getContactLeads(
      {String? status, String? type});
  Future<Result<ContactLead>> updateContactLeadStatus(
      {required String id, required String status});

  Future<Result<bool>> submitContactForm({
    required String name,
    required String email,
    required String phone,
    required String message,
    required bool bookDemo,
  });
}

import '../models/contact_lead_model.dart';

abstract class ContactLeadDataSource {
  Future<List<ContactLeadModel>> getContactLeads(
      {String? status, String? type});
  Future<ContactLeadModel> updateContactLeadStatus(
      {required String id, required String status});
}

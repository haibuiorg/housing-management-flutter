import 'package:dio/dio.dart';
import 'package:priorli/core/contact_leads/data/contact_lead_data_source.dart';
import 'package:priorli/core/contact_leads/models/contact_lead_model.dart';

import '../../base/exceptions.dart';

class ContactLeadRemoteDataSource implements ContactLeadDataSource {
  final Dio client;

  ContactLeadRemoteDataSource({required this.client});

  @override
  Future<List<ContactLeadModel>> getContactLeads(
      {String? status, String? type}) async {
    try {
      final Map<String, dynamic> data = {
        'status': status,
        'type': type,
      };
      data.removeWhere((key, value) => value == null);
      final result =
          await client.get('/admin/contact_leads', queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => ContactLeadModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ContactLeadModel> updateContactLeadStatus(
      {required String id, required String status}) async {
    try {
      final data = {
        'status': status,
        'id': id,
      };
      final result = await client.put('/admin/contact_leads', data: data);
      return ContactLeadModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

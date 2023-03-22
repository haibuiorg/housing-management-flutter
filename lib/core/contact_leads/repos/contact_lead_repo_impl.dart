import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/contact_leads/data/contact_lead_data_source.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../entities/contact_lead.dart';
import 'contact_lead_repo.dart';

class ContactLeadRepoImpl extends ContactLeadRepo {
  final ContactLeadDataSource remoteDataSource;

  ContactLeadRepoImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Result<ContactLead>> updateContactLeadStatus(
      {required String id, required String status}) async {
    try {
      final result = await remoteDataSource.updateContactLeadStatus(
          id: id, status: status);
      return ResultSuccess(ContactLead.modelToEntity(result));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<ContactLead>>> getContactLeads(
      {String? status, String? type}) async {
    try {
      final result =
          await remoteDataSource.getContactLeads(status: status, type: type);
      return ResultSuccess(result.map(ContactLead.modelToEntity).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> submitContactForm(
      {required String name,
      required String email,
      required String phone,
      required String message,
      required bool bookDemo}) async {
    try {
      final result = await remoteDataSource.submitContactForm(
          name: name,
          email: email,
          phone: phone,
          message: message,
          bookDemo: bookDemo);
      return ResultSuccess(result);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

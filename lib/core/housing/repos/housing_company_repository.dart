import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/user/entities/user.dart';

import '../../base/result.dart';
import '../../storage/entities/storage_item.dart';
import '../entities/ui.dart';

abstract class HousingCompanyRepository {
  Future<Result<List<HousingCompany>>> getHousingCompanies();
  Future<Result<HousingCompany>> getHousingCompany(
      {required String housingCompanyId});
  Future<Result<HousingCompany>> deleteHousingCompany(
      {required String housingCompanyId});
  Future<Result<HousingCompany>> updateHousingCompanyInfo(
      {String? name,
      required String housingCompanyId,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      double? lat,
      double? lng,
      String? city,
      String? countryCode,
      UI? ui,
      String? coverImageStorageLink,
      String? logoStorageLink});
  Future<Result<HousingCompany>> createHousingCompany(
      {required String name, required String countryCode, String? businessId});

  Future<Result<List<StorageItem>>> addCompanyDocuments(
      {required List<String> storageItems,
      required String housingCompanyId,
      String? type});
  Future<Result<List<StorageItem>>> getCompanyDocuments({
    required String housingCompanyId,
    String? type,
    int? limit,
    int? lastCreatedOn,
  });
  Future<Result<StorageItem>> updateCompanyDocument(
      {required String documentId,
      required String housingCompanyId,
      bool? isDeleted,
      String? name});
  Future<Result<StorageItem>> getCompanyDocument({
    required String documentId,
    required String housingCompanyId,
  });

  Future<Result<List<User>>> getCompanyUsers({
    required String housingCompanyId,
  });

  Future<Result<List<User>>> getHousingCompanyManagers({
    required String companyId,
  });
  Future<Result<User>> addHousingCompanyManager(
      {required String housingCompanyId,
      required String email,
      String? firstName,
      String? lastName,
      String? phoneNumber});
  Future<Result<List<HousingCompany>>> adminGetCompanies(
      {required int lastCreatedOn, required int limit});
  Future<Result<List<User>>> removeHousingCompanyManager({
    required String housingCompanyId,
    required String removedUserId,
  });
  Future<Result<bool>> removeTenantFromCompany({
    required String housingCompanyId,
    required String removedUserId,
  });
}

import 'package:priorli/core/housing/models/housing_company_model.dart';
import 'package:priorli/core/user/models/user_model.dart';

import '../../storage/models/storage_item_model.dart';
import '../entities/ui.dart';

abstract class HousingCompanyDataSource {
  Future<HousingCompanyModel> createHousingCompany(
      {required String name, required String countryCode});
  Future<List<UserModel>> getHousingCompanyManagers({
    required String companyId,
  });
  Future<UserModel> addHousingCompanyManager(
      {required String housingCompanyId,
      required String email,
      String? firstName,
      String? lastName,
      String? phoneNumber});
  Future<HousingCompanyModel> updateHousingCompanyInfo(
      {String? name,
      required String housingCompanyId,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      double? lat,
      double? lng,
      String? coverImageStorageLink,
      String? logoStorageLink,
      String? city,
      UI? ui,
      String? countryCode});
  Future<List<HousingCompanyModel>> getUserHousingCompanies();
  Future<HousingCompanyModel> getHousingCompany(
      {required String housingCompanyId});
  Future<HousingCompanyModel> deleteHousingCompany(
      {required String housingCompanyId});

  Future<List<StorageItemModel>> addCompanyDocuments(
      {required List<String> storageItems,
      required String housingCompanyId,
      String? type});
  Future<List<StorageItemModel>> getCompanyDocuments({
    required String housingCompanyId,
    String? type,
    int? limit,
    int? lastCreatedOn,
  });
  Future<StorageItemModel> updateCompanyDocument(
      {required String documentId,
      required String housingCompanyId,
      bool? isDeleted,
      String? name});
  Future<StorageItemModel> getCompanyDocument({
    required String documentId,
    required String housingCompanyId,
  });

  Future<List<UserModel>> getCompanyUsers({
    required String housingCompanyId,
  });

  Future<List<HousingCompanyModel>> adminGetCompanies({
    required int lastCreatedOn,
    required int limit,
  });
}

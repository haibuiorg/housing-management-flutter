import 'package:dio/dio.dart';
import 'package:priorli/core/housing/models/housing_company_model.dart';
import 'package:priorli/core/user/models/user_model.dart';

import '../../base/exceptions.dart';
import '../../storage/models/storage_item_model.dart';
import '../entities/ui.dart';
import './housing_company_data_source.dart';

class HousingCompanyRemoteDataSource implements HousingCompanyDataSource {
  final Dio client;
  final String _path = '/housing_company';

  HousingCompanyRemoteDataSource(this.client);
  @override
  Future<HousingCompanyModel> createHousingCompany(
      {required String name,
      required String countryCode,
      String? businessId}) async {
    final Map<String, dynamic> data = {
      'name': name,
      'country_code': countryCode,
      'business_id': businessId,
    };
    data.removeWhere((key, value) => value == null);
    try {
      final result = await client.post(_path, data: data);
      return HousingCompanyModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<HousingCompanyModel>> getUserHousingCompanies() async {
    try {
      final result = await client.get('$_path/all');
      return (result.data as List<dynamic>)
          .map((json) => HousingCompanyModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<HousingCompanyModel> updateHousingCompanyInfo(
      {String? name,
      required String housingCompanyId,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      String? coverImageStorageLink,
      String? logoStorageLink,
      double? lat,
      double? lng,
      UI? ui,
      String? countryCode,
      String? city}) async {
    final Map<String, dynamic> data = {
      'housing_company_id': housingCompanyId,
    };
    if (name != null) {
      data['name'] = name;
    }
    if (streetAddress1 != null) {
      data['street_address_1'] = streetAddress1;
    }
    if (streetAddress2 != null) {
      data['street_address_2'] = streetAddress2;
    }
    if (postalCode != null) {
      data['postal_code'] = postalCode;
    }
    if (lat != null) {
      data['lat'] = lat;
    }
    if (lng != null) {
      data['lng'] = lng;
    }
    if (city != null) {
      data['city'] = city;
    }
    if (countryCode != null) {
      data['country_code'] = countryCode;
    }
    if (ui != null) {
      data['ui'] = {'seed_color': ui.seedColor};
    }
    if (coverImageStorageLink != null) {
      data['cover_image_storage_link'] = coverImageStorageLink;
    }
    if (logoStorageLink != null) {
      data['logo_storage_link'] = logoStorageLink;
    }
    try {
      final result = await client.put(_path, data: data);
      return HousingCompanyModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<HousingCompanyModel> getHousingCompany(
      {required String housingCompanyId}) async {
    try {
      final Map<String, dynamic> data = {
        'housing_company_id': housingCompanyId,
      };
      final result = await client.get(_path, queryParameters: data);
      return HousingCompanyModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<HousingCompanyModel> deleteHousingCompany(
      {required String housingCompanyId}) async {
    try {
      final Map<String, dynamic> data = {
        'housing_company_id': housingCompanyId,
        'is_deleted': true
      };
      final result = await client.put(_path, data: data);
      return HousingCompanyModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<StorageItemModel>> addCompanyDocuments(
      {required List<String> storageItems,
      required String housingCompanyId,
      String? type}) async {
    try {
      final data = {
        'housing_company_id': housingCompanyId,
        'storage_items': storageItems,
        'type': type
      };
      final result =
          await client.post('/housing_company/documents', data: data);
      return (result.data as List<dynamic>)
          .map((e) => StorageItemModel.fromJson(e))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<StorageItemModel> getCompanyDocument(
      {required String documentId, required String housingCompanyId}) async {
    try {
      final result = await client.get(
        '/housing_company/$housingCompanyId/document/$documentId',
      );
      return StorageItemModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<StorageItemModel>> getCompanyDocuments({
    required String housingCompanyId,
    String? type,
    int? limit,
    int? lastCreatedOn,
  }) async {
    try {
      final data = {
        'housing_company_id': housingCompanyId,
        'type': type,
        'last_created_on': lastCreatedOn,
        'limit': limit
      };
      data.removeWhere((key, value) => value == null);
      final result =
          await client.get('/housing_company/documents', queryParameters: data);
      return (result.data as List<dynamic>)
          .map((e) => StorageItemModel.fromJson(e))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<StorageItemModel> updateCompanyDocument(
      {required String documentId,
      required String housingCompanyId,
      bool? isDeleted,
      String? name}) async {
    try {
      final Map<String, dynamic> data = {
        'housing_company_id': housingCompanyId,
      };
      if (isDeleted != null) {
        data['is_deleted'] = isDeleted;
      }
      if (name != null) {
        data['name'] = name;
      }
      final result =
          await client.put('/housing_company/document/$documentId', data: data);
      return StorageItemModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<UserModel>> getCompanyUsers(
      {required String housingCompanyId}) async {
    try {
      final result = await client.get(
        '/housing_company/$housingCompanyId/users',
      );
      return (result.data as List<dynamic>)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<UserModel> addHousingCompanyManager(
      {required String housingCompanyId,
      required String email,
      String? firstName,
      String? lastName,
      String? phoneNumber}) async {
    try {
      final Map<String, dynamic> data = {
        'housing_company_id': housingCompanyId,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phoneNumber,
      };
      data.removeWhere((key, value) => value == null);
      final result = await client.post('/housing_company_manager', data: data);
      return UserModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<UserModel>> getHousingCompanyManagers({
    required String companyId,
  }) async {
    try {
      final result = await client.get(
        '/housing_company_manager/$companyId',
      );
      return (result.data as List<dynamic>)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<HousingCompanyModel>> adminGetCompanies(
      {required int lastCreatedOn, required int limit}) async {
    try {
      final result = await client.get('/admin/companies',
          queryParameters: {'last_created_on': lastCreatedOn, 'limit': limit});
      return (result.data as List<dynamic>)
          .map((e) => HousingCompanyModel.fromJson(e))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<UserModel>> removeHousingCompanyManager(
      {required String housingCompanyId, required String removedUserId}) async {
    try {
      final Map<String, dynamic> data = {
        'housing_company_id': housingCompanyId,
        'removed_user_id': removedUserId,
      };
      final result =
          await client.delete('/housing_company_manager', data: data);
      return (result.data as List<dynamic>)
          .map((e) => UserModel.fromJson(e))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<bool> removeTenantFromCompany(
      {required String housingCompanyId, required String removedUserId}) async {
    try {
      final Map<String, dynamic> data = {
        'housing_company_id': housingCompanyId,
        'removed_user_id': removedUserId,
      };
      final result = await client.delete('/housing_company/tenant', data: data);
      return result.data;
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

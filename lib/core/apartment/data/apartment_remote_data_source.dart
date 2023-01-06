import 'package:dio/dio.dart';
import 'package:priorli/core/apartment/data/apartment_data_source.dart';
import 'package:priorli/core/apartment/model/apartment_invitation_model.dart';
import 'package:priorli/core/apartment/model/apartment_model.dart';
import 'package:priorli/core/storage/models/storage_item_model.dart';

import '../../base/exceptions.dart';

class ApartmentRemoteDataSource implements ApartmentDataSource {
  final Dio client;
  final _path = '/apartments';
  ApartmentRemoteDataSource(this.client);

  @override
  Future<List<ApartmentModel>> addApartments(
      {required String housingCompanyId,
      required String building,
      List<String>? houseCodes}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "building": building,
      };
      if (houseCodes != null) {
        data["house_codes"] = houseCodes;
      }
      final result = await client.post(_path, data: data);
      return (result.data as List<dynamic>)
          .map((json) => ApartmentModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<ApartmentModel>> getUserApartments({
    required String housingCompanyId,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
      };
      final result = await client.get(_path, queryParameters: data);
      return (result.data as List<dynamic>)
          .map((json) => ApartmentModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ApartmentInvitationModel> sendInvitationToApartment(
      {required String apartmentId,
      required String housingCompanyId,
      required int numberOfTenants,
      List<String>? emails}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "apartment_id": apartmentId,
        "number_of_tenants": numberOfTenants,
      };
      if (emails != null) {
        data["emails"] = emails;
      }
      final result = await client.post('$_path/invite', data: data);
      return ApartmentInvitationModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ApartmentModel> getUserApartment(
      {required String housingCompanyId, required String apartmentId}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "apartment_id": apartmentId,
      };
      final result = await client.get('/apartment', queryParameters: data);
      return ApartmentModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ApartmentModel> deleteApartment(
      {required String housingCompanyId, required String apartmentId}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "apartment_id": apartmentId,
        "is_deleted": true
      };
      final result = await client.put('/apartment', data: data);
      return ApartmentModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ApartmentModel> editApartmentInfo(
      {required String housingCompanyId,
      required String apartmentId,
      String? building,
      String? houseCode}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "apartment_id": apartmentId,
      };
      if (building != null) {
        data['building'] = building;
      }
      if (houseCode != null) {
        data['house_code'] = houseCode;
      }
      final result = await client.put('/apartment', data: data);
      return ApartmentModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<ApartmentModel> joinApartment(
      {required String invitationCode,
      required String housingCompanyId}) async {
    try {
      final Map<String, dynamic> data = {
        "housing_company_id": housingCompanyId,
        "invitation_code": invitationCode,
      };
      final result = await client.post('/apartment/join_with_code', data: data);
      return ApartmentModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<StorageItemModel>> addApartmentDocuments(
      {required List<String> storageItems,
      required String housingCompanyId,
      required String apartmentId,
      String? type}) async {
    try {
      final data = {
        'housing_company_id': housingCompanyId,
        'apartment_id': apartmentId,
        'storage_items': storageItems,
        'type': type
      };
      final result = await client.post('/apartment/documents', data: data);
      return (result.data as List<dynamic>)
          .map((e) => StorageItemModel.fromJson(e))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<StorageItemModel> getApartmentDocument(
      {required String documentId,
      required String housingCompanyId,
      required String apartmentId}) async {
    try {
      final result = await client.get(
        '/housing_company/$housingCompanyId/apartment/$apartmentId/document/$documentId',
      );
      return StorageItemModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<StorageItemModel>> getApartmentDocuments(
      {required String housingCompanyId,
      required String apartmentId,
      int? limit,
      int? lastCreatedOn,
      String? type}) async {
    try {
      final Map<String, dynamic> data = {
        'housing_company_id': housingCompanyId,
        'apartment_id': apartmentId,
        'type': type,
        'limit': limit,
        'last_created_on': lastCreatedOn,
      };
      data.removeWhere((key, value) => value == null);
      final result =
          await client.get('/apartment/documents', queryParameters: data);
      return (result.data as List<dynamic>)
          .map((e) => StorageItemModel.fromJson(e))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<StorageItemModel> updateApartmentDocument(
      {required String documentId,
      required String housingCompanyId,
      required String apartmentId,
      bool? isDeleted,
      String? name}) async {
    try {
      final Map<String, dynamic> data = {
        'housing_company_id': housingCompanyId,
        'apartment_id': apartmentId,
      };
      if (isDeleted != null) {
        data['is_deleted'] = isDeleted;
      }
      if (name != null) {
        data['name'] = name;
      }
      final result =
          await client.put('/apartment/document/$documentId', data: data);
      return StorageItemModel.fromJson(result.data);
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

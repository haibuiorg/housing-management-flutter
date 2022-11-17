import 'dart:math';

import 'package:dio/dio.dart';
import 'package:priorli/core/apartment/data/apartment_data_source.dart';
import 'package:priorli/core/apartment/model/apartment_invitation_model.dart';
import 'package:priorli/core/apartment/model/apartment_model.dart';

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
      throw ServerException();
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
      throw ServerException();
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
      print(data);
      final result = await client.post('$_path/invite', data: data);
      return ApartmentInvitationModel.fromJson(result.data);
    } catch (error) {
      print(error);
      throw ServerException();
    }
  }
}

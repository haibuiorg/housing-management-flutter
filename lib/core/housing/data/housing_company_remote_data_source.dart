import 'package:dio/dio.dart';
import 'package:priorli/core/housing/models/housing_company_model.dart';

import '../../base/exceptions.dart';
import './housing_company_data_source.dart';

class HousingCompanyRemoteDataSource implements HousingCompanyDataSource {
  final Dio client;
  final String _path = '/housing_company';

  HousingCompanyRemoteDataSource(this.client);
  @override
  Future<HousingCompanyModel> createHousingCompany(
      {required String name}) async {
    final Map<String, dynamic> data = {
      "name": name,
    };
    try {
      final result = await client.post(_path, data: data);
      return HousingCompanyModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException();
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
      throw ServerException();
    }
  }

  @override
  Future<HousingCompanyModel> updateHousingCompanyInfo(
      {String? name,
      required String housingCompanyId,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      double? lat,
      double? lng,
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
    try {
      final result = await client.put(_path, data: data);
      return HousingCompanyModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException();
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
      throw ServerException();
    }
  }
}

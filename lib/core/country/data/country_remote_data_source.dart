import 'package:dio/dio.dart';
import 'package:priorli/core/country/data/country_data_source.dart';
import 'package:priorli/core/country/models/country_model.dart';

import '../../base/exceptions.dart';

class CountryRemoteDataSource implements CountryDataSource {
  final Dio client;

  CountryRemoteDataSource({required this.client});
  @override
  Future<CountryModel> getCountryData({required String countryId}) async {
    try {
      final data = {
        'id': countryId,
      };
      final result = await client.get('/country', queryParameters: data);
      return CountryModel.fromJson(result.data as Map<String, dynamic>);
    } catch (error) {
      throw ServerException(error: error);
    }
  }

  @override
  Future<List<CountryModel>> getSupportCountries() async {
    try {
      final result = await client.get('/countries');
      return (result.data as List<dynamic>)
          .map((json) => CountryModel.fromJson(json))
          .toList();
    } catch (error) {
      throw ServerException(error: error);
    }
  }
}

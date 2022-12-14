import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/country/entities/country.dart';

abstract class CountryRepository {
  Future<Result<List<Country>>> getSupportCountries();
  Future<Result<Country>> getCountryData({required String countryId});
}

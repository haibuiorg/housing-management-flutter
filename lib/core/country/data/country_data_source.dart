import 'package:priorli/core/country/models/country_model.dart';

abstract class CountryDataSource {
  Future<List<CountryModel>> getSupportCountries();
  Future<CountryModel> getCountryData({required String countryId});
}

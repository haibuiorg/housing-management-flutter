import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/country/entities/country.dart';

import '../entities/legal_document.dart';

abstract class CountryRepository {
  Future<Result<List<Country>>> getSupportCountries();
  Future<Result<Country>> getCountryData({required String countryId});
  Future<Result<List<LegalDocument>>> getCountryLegalDocuments(
      {required String countryCode});
}

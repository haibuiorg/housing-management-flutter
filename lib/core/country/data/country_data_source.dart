import 'package:priorli/core/country/models/country_model.dart';
import 'package:priorli/core/country/models/legal_document_model.dart';

abstract class CountryDataSource {
  Future<List<CountryModel>> getSupportCountries();
  Future<CountryModel> getCountryData({required String countryId});
  Future<List<LegalDocumentModel>> getCountryLegalDocuments(
      {required String countryCode});
}

import 'package:priorli/core/housing/models/housing_company_model.dart';

abstract class HousingCompanyDataSource {
  Future<HousingCompanyModel> createHousingCompany({required String name});
  Future<HousingCompanyModel> updateHousingCompanyInfo(
      {String? name,
      required String housingCompanyId,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      double? lat,
      double? lng,
      String? city,
      String? countryCode});
  Future<List<HousingCompanyModel>> getUserHousingCompanies();
}

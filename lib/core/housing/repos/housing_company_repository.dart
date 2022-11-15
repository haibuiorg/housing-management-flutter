import 'package:priorli/core/housing/entities/housing_company.dart';

import '../../base/result.dart';

abstract class HousingCompanyRepository {
  Future<Result<List<HousingCompany>>> getHousingCompanies();
  Future<Result<HousingCompany>> updateHousingCompanyInfo({
    String? name,
    required String housingCompanyId,
    String? streetAddress1,
    String? streetAddress2,
    String? postalCode,
    double? lat,
    double? lng,
    String? city,
    String? countryCode,
  });
  Future<Result<HousingCompany>> createHousingCompany({required String name});
}

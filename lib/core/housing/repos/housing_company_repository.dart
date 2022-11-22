import 'package:priorli/core/housing/entities/housing_company.dart';

import '../../base/result.dart';
import '../entities/ui.dart';

abstract class HousingCompanyRepository {
  Future<Result<List<HousingCompany>>> getHousingCompanies();
  Future<Result<HousingCompany>> getHousingCompany(
      {required String housingCompanyId});
  Future<Result<HousingCompany>> deleteHousingCompany(
      {required String housingCompanyId});
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
    UI? ui,
  });
  Future<Result<HousingCompany>> createHousingCompany({required String name});
}

import 'package:priorli/core/base/usecase.dart';

import '../../base/result.dart';
import '../entities/housing_company.dart';
import '../repos/housing_company_repository.dart';

class GetHousingCompanies extends UseCase<List<HousingCompany>, NoParams> {
  final HousingCompanyRepository housingCompanyRepository;

  GetHousingCompanies({required this.housingCompanyRepository});

  @override
  Future<Result<List<HousingCompany>>> call(NoParams params) {
    return housingCompanyRepository.getHousingCompanies();
  }
}

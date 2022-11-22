import 'package:priorli/core/base/usecase.dart';

import '../../base/result.dart';
import '../entities/housing_company.dart';
import '../repos/housing_company_repository.dart';
import 'get_housing_company.dart';

class DeleteHousingCompany
    extends UseCase<HousingCompany, GetHousingCompanyParams> {
  final HousingCompanyRepository housingCompanyRepository;

  DeleteHousingCompany({required this.housingCompanyRepository});

  @override
  Future<Result<HousingCompany>> call(GetHousingCompanyParams params) {
    return housingCompanyRepository.deleteHousingCompany(
        housingCompanyId: params.housingCompanyId);
  }
}

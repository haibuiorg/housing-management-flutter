import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/user/entities/user.dart';

import '../../base/result.dart';
import '../repos/housing_company_repository.dart';
import 'get_housing_company.dart';

class GetHousingCompanyUsers
    extends UseCase<List<User>, GetHousingCompanyParams> {
  final HousingCompanyRepository housingCompanyRepository;

  GetHousingCompanyUsers({required this.housingCompanyRepository});

  @override
  Future<Result<List<User>>> call(GetHousingCompanyParams params) {
    return housingCompanyRepository.getCompanyUsers(
        housingCompanyId: params.housingCompanyId);
  }
}

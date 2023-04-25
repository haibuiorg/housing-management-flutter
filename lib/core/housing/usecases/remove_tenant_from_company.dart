import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';
import 'package:priorli/core/housing/usecases/remove_housing_company_manager.dart';

import '../../base/usecase.dart';

class RemoveTenantFromCompany extends UseCase<bool, RemoveUserParams> {
  final HousingCompanyRepository repository;

  RemoveTenantFromCompany(this.repository);

  @override
  Future<Result<bool>> call(RemoveUserParams params) async {
    return await repository.removeTenantFromCompany(
        housingCompanyId: params.companyId, removedUserId: params.userId);
  }
}

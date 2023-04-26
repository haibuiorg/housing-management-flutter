import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';

import '../../base/usecase.dart';

class AdminGetCompanies
    extends UseCase<List<HousingCompany>, AdminHousingCompanyParams> {
  final HousingCompanyRepository repository;

  AdminGetCompanies({required this.repository});

  @override
  Future<Result<List<HousingCompany>>> call(AdminHousingCompanyParams params) {
    return repository.adminGetCompanies(
        lastCreatedOn:
            params.lastCreatedOn ?? DateTime.now().millisecondsSinceEpoch,
        limit: params.limit ?? 10);
  }
}

class AdminHousingCompanyParams extends Equatable {
  final int? lastCreatedOn;
  final int? limit;

  const AdminHousingCompanyParams({this.lastCreatedOn, this.limit});

  @override
  List<Object?> get props => [lastCreatedOn, limit];
}

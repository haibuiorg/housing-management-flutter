import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/usecase.dart';

import '../../base/result.dart';
import '../entities/housing_company.dart';
import '../repos/housing_company_repository.dart';

class GetHousingCompany
    extends UseCase<HousingCompany, GetHousingCompanyParams> {
  final HousingCompanyRepository housingCompanyRepository;

  GetHousingCompany({required this.housingCompanyRepository});

  @override
  Future<Result<HousingCompany>> call(GetHousingCompanyParams params) {
    return housingCompanyRepository.getHousingCompany(
        housingCompanyId: params.housingCompanyId);
  }
}

class GetHousingCompanyParams extends Equatable {
  final String housingCompanyId;

  const GetHousingCompanyParams({
    required this.housingCompanyId,
  });

  @override
  List<Object?> get props => [housingCompanyId];
}

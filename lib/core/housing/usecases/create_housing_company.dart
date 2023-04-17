import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/housing_company.dart';
import '../repos/housing_company_repository.dart';

class CreateHousingCompany
    extends UseCase<HousingCompany, CreateHousingCompanyParams> {
  final HousingCompanyRepository housingCompanyRepository;

  CreateHousingCompany({required this.housingCompanyRepository});

  @override
  Future<Result<HousingCompany>> call(CreateHousingCompanyParams params) {
    return housingCompanyRepository.createHousingCompany(
        name: params.name,
        countryCode: params.countryCode,
        businessId: params.businessId);
  }
}

class CreateHousingCompanyParams extends Equatable {
  final String name;
  final String countryCode;
  final String? businessId;

  const CreateHousingCompanyParams({
    required this.name,
    required this.countryCode,
    this.businessId,
  });
  @override
  List<Object?> get props => [name, countryCode, businessId];
}

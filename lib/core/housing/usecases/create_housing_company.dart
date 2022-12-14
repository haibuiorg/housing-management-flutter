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
        name: params.name, countryCode: params.countryCode);
  }
}

class CreateHousingCompanyParams extends Equatable {
  final String name;
  final String countryCode;

  const CreateHousingCompanyParams({
    required this.name,
    required this.countryCode,
  });
  @override
  List<Object?> get props => [name, countryCode];
}

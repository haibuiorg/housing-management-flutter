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
    return housingCompanyRepository.createHousingCompany(name: params.name);
  }
}

class CreateHousingCompanyParams extends Equatable {
  final String name;

  const CreateHousingCompanyParams({
    required this.name,
  });
  @override
  List<Object?> get props => [name];
}

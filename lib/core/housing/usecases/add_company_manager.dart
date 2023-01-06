import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';
import 'package:priorli/core/user/entities/user.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';

class AddCompanyManager extends UseCase<User, AddCompanyManagerParams> {
  final HousingCompanyRepository housingCompanyRepository;

  AddCompanyManager({required this.housingCompanyRepository});
  @override
  Future<Result<User>> call(AddCompanyManagerParams params) {
    return housingCompanyRepository.addHousingCompanyManager(
        housingCompanyId: params.companyId,
        email: params.email,
        firstName: params.firstName,
        lastName: params.lastName,
        phoneNumber: params.phone);
  }
}

class AddCompanyManagerParams extends Equatable {
  final String companyId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;

  const AddCompanyManagerParams(
      {required this.companyId,
      required this.email,
      this.firstName,
      this.lastName,
      this.phone});

  @override
  List<Object?> get props => [companyId, email, firstName, lastName, phone];
}

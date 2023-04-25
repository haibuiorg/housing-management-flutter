import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/user/entities/user.dart';

import '../repos/housing_company_repository.dart';

class RemoveHousingCompanyManager
    extends UseCase<List<User>, RemoveUserParams> {
  final HousingCompanyRepository housingCompanyRepository;

  RemoveHousingCompanyManager(this.housingCompanyRepository);
  @override
  Future<Result<List<User>>> call(RemoveUserParams params) {
    return housingCompanyRepository.removeHousingCompanyManager(
        housingCompanyId: params.companyId, removedUserId: params.userId);
  }
}

class RemoveUserParams extends Equatable {
  final String companyId;
  final String userId;

  const RemoveUserParams({required this.companyId, required this.userId});

  @override
  List<Object?> get props => [companyId, userId];
}

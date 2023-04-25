import 'package:priorli/core/apartment/repos/apartment_repository.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/user/entities/user.dart';

import 'get_apartment.dart';

class GetApartmentTenants
    extends UseCase<List<User>, GetApartmentSingleParams> {
  final ApartmentRepository apartmentRepository;

  GetApartmentTenants(this.apartmentRepository);
  @override
  Future<Result<List<User>>> call(GetApartmentSingleParams params) {
    return apartmentRepository.getApartmentTenants(
        apartmentId: params.apartmentId,
        housingCompanyId: params.housingCompanyId);
  }
}

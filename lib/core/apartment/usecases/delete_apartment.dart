import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/apartment.dart';
import '../repos/apartment_repository.dart';
import 'get_apartment.dart';

class DeleteApartment extends UseCase<Apartment, GetApartmentSingleParams> {
  final ApartmentRepository apartmentRepository;

  DeleteApartment({required this.apartmentRepository});
  @override
  Future<Result<Apartment>> call(GetApartmentSingleParams params) {
    return apartmentRepository.deleteUserApartment(
        apartmentId: params.apartmentId,
        housingCompanyId: params.housingCompanyId);
  }
}

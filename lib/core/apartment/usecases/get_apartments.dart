import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/apartment.dart';
import '../repos/apartment_repository.dart';

class GetApartments extends UseCase<List<Apartment>, NoParams> {
  final ApartmentRepository apartmentRepository;

  GetApartments({required this.apartmentRepository});
  @override
  Future<Result<List<Apartment>>> call(NoParams params) {
    return apartmentRepository.getUserApartments();
  }
}

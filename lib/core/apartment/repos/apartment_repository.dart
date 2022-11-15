import '../../base/result.dart';
import '../entities/apartment.dart';
import '../entities/apartment_invitation.dart';

abstract class ApartmentRepository {
  Future<Result<List<Apartment>>> addApartments({
    required String housingCompanyId,
    required String building,
    List<String>? houseCodes,
  });
  Future<Result<List<Apartment>>> getUserApartments();
  Future<Result<ApartmentInvitation>> sendInvitationToApartment(
      {required String apartmentId,
      required String housingCompanyId,
      required int numberOfTenants,
      List<String>? emails});
}

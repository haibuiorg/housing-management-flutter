import 'package:priorli/core/apartment/model/apartment_invitation_model.dart';
import 'package:priorli/core/apartment/model/apartment_model.dart';

abstract class ApartmentDataSource {
  Future<List<ApartmentModel>> addApartments({
    required String housingCompanyId,
    required String building,
    List<String>? houseCodes,
  });
  Future<List<ApartmentModel>> getUserApartments({
    required String housingCompanyId,
  });
  Future<ApartmentModel> getUserApartment({
    required String housingCompanyId,
    required String apartmentId,
  });
  Future<ApartmentModel> editApartmentInfo({
    required String housingCompanyId,
    required String apartmentId,
    String? building,
    String? houseCode,
  });
  Future<ApartmentModel> deleteApartment({
    required String housingCompanyId,
    required String apartmentId,
  });
  Future<ApartmentInvitationModel> sendInvitationToApartment(
      {required String apartmentId,
      required String housingCompanyId,
      required int numberOfTenants,
      List<String>? emails});
}

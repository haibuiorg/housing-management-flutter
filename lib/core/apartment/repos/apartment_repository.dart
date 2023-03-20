import '../../base/result.dart';
import '../../storage/entities/storage_item.dart';
import '../entities/apartment.dart';
import '../entities/apartment_invitation.dart';

abstract class ApartmentRepository {
  Future<Result<List<Apartment>>> addApartments({
    required String housingCompanyId,
    required String building,
    List<String>? houseCodes,
  });
  Future<Result<List<Apartment>>> getUserApartments({
    required String housingCompanyId,
  });
  Future<Result<Apartment>> getUserApartment(
      {required String housingCompanyId, required String apartmentId});
  Future<Result<Apartment>> editApartmentInfo(
      {required String housingCompanyId,
      required String apartmentId,
      String? building,
      String? houseCode});
  Future<Result<Apartment>> deleteUserApartment(
      {required String housingCompanyId, required String apartmentId});
  Future<Result<ApartmentInvitation>> sendInvitationToApartment(
      {required String apartmentId,
      required String housingCompanyId,
      required int numberOfTenants,
      List<String>? emails});
  Future<Result<Apartment>> joinApartment({
    required String invitationCode,
  });
  Future<Result<List<StorageItem>>> addApartmentDocuments(
      {required List<String> storageItems,
      required String housingCompanyId,
      required String apartmentId,
      String? type});
  Future<Result<List<StorageItem>>> getApartmentDocuments(
      {required String housingCompanyId,
      required String apartmentId,
      int? limit,
      int? lastCreatedOn,
      String? type});
  Future<Result<StorageItem>> updateApartmentDocument(
      {required String documentId,
      required String housingCompanyId,
      required String apartmentId,
      bool? isDeleted,
      String? name});
  Future<Result<StorageItem>> getApartmentDocument({
    required String documentId,
    required String housingCompanyId,
    required String apartmentId,
  });
}

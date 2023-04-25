import 'package:priorli/core/user/entities/user.dart';

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
      List<String>? ownersIds,
      String? building,
      String? houseCode});
  Future<Result<Apartment>> deleteUserApartment(
      {required String housingCompanyId, required String apartmentId});
  Future<Result<ApartmentInvitation>> sendInvitationToApartment(
      {required String apartmentId,
      required String housingCompanyId,
      required bool setAsApartmentOwner,
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
  Future<Result<List<ApartmentInvitation>>> getApartmentInvitations(
      {required String apartmentId,
      required String housingCompanyId,
      //pending, expired, accepted
      required String status});
  Future<Result<ApartmentInvitation>> resentApartmentInvitation({
    required String invitationId,
    required String housingCompanyId,
  });
  Future<Result<List<ApartmentInvitation>>> cancelApartmentInvitation({
    required List<String> invitationIds,
    required String housingCompanyId,
  });
  Future<Result<bool>> removeTenantFromApartment({
    required String housingCompanyId,
    required String apartmentId,
    required String removedUserId,
  });
  Future<Result<List<User>>> getApartmentTenants({
    required String housingCompanyId,
    required String apartmentId,
  });
}

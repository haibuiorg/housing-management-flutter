import 'package:priorli/core/apartment/model/apartment_invitation_model.dart';
import 'package:priorli/core/apartment/model/apartment_model.dart';
import 'package:priorli/core/storage/models/storage_item_model.dart';
import 'package:priorli/core/user/models/user_model.dart';

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
    List<String>? ownersIds,
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
      required bool setAsApartmentOwner,
      List<String>? emails});
  Future<List<ApartmentInvitationModel>> getApartmentInvitations(
      {required String apartmentId,
      required String housingCompanyId,
      //pending, expired, accepted
      required String status});
  Future<ApartmentInvitationModel> resentApartmentInvitation(
      {required String invitationId, required String housingCompanyId});
  Future<List<ApartmentInvitationModel>> cancelApartmentInvitation(
      {required List<String> invitationIds, required String housingCompanyId});

  Future<ApartmentModel> joinApartment({
    required String invitationCode,
  });

  Future<List<StorageItemModel>> addApartmentDocuments(
      {required List<String> storageItems,
      required String housingCompanyId,
      required String apartmentId,
      String? type});
  Future<List<StorageItemModel>> getApartmentDocuments(
      {required String housingCompanyId,
      int? limit,
      int? lastCreatedOn,
      required String apartmentId,
      String? type});
  Future<StorageItemModel> updateApartmentDocument(
      {required String documentId,
      required String housingCompanyId,
      required String apartmentId,
      bool? isDeleted,
      String? name});
  Future<StorageItemModel> getApartmentDocument({
    required String documentId,
    required String housingCompanyId,
    required String apartmentId,
  });
  Future<bool> removeTenantFromApartment({
    required String housingCompanyId,
    required String apartmentId,
    required String removedUserId,
  });
  Future<List<UserModel>> getApartmentTenants({
    required String housingCompanyId,
    required String apartmentId,
  });
}

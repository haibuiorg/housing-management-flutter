import 'package:priorli/core/apartment/model/apartment_invitation_model.dart';
import 'package:priorli/core/apartment/model/apartment_model.dart';
import 'package:priorli/core/storage/models/storage_item_model.dart';

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
}

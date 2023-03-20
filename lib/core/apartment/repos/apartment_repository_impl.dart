import 'package:priorli/core/storage/entities/storage_item.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../../base/result.dart';
import '../data/apartment_data_source.dart';
import '../entities/apartment.dart';
import '../entities/apartment_invitation.dart';
import 'apartment_repository.dart';

class ApartmentRepositoryImpl implements ApartmentRepository {
  final ApartmentDataSource apartmentDataSource;

  ApartmentRepositoryImpl({required this.apartmentDataSource});

  @override
  Future<Result<List<Apartment>>> addApartments(
      {required String housingCompanyId,
      required String building,
      List<String>? houseCodes}) async {
    try {
      final apartmentModels = await apartmentDataSource.addApartments(
          housingCompanyId: housingCompanyId,
          building: building,
          houseCodes: houseCodes);
      return ResultSuccess(
          apartmentModels.map((e) => Apartment.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<Apartment>>> getUserApartments({
    required String housingCompanyId,
  }) async {
    try {
      final apartmentModels = await apartmentDataSource.getUserApartments(
          housingCompanyId: housingCompanyId);
      return ResultSuccess(
          apartmentModels.map((e) => Apartment.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<ApartmentInvitation>> sendInvitationToApartment(
      {required String apartmentId,
      required String housingCompanyId,
      required int numberOfTenants,
      List<String>? emails}) async {
    try {
      final invitationModel =
          await apartmentDataSource.sendInvitationToApartment(
              housingCompanyId: housingCompanyId,
              apartmentId: apartmentId,
              numberOfTenants: numberOfTenants,
              emails: emails);
      return ResultSuccess(ApartmentInvitation.modelToEntity(invitationModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Apartment>> getUserApartment(
      {required String housingCompanyId, required String apartmentId}) async {
    try {
      final apartmentModel = await apartmentDataSource.getUserApartment(
          housingCompanyId: housingCompanyId, apartmentId: apartmentId);
      return ResultSuccess(Apartment.modelToEntity(apartmentModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Apartment>> deleteUserApartment(
      {required String housingCompanyId, required String apartmentId}) async {
    try {
      final apartmentModel = await apartmentDataSource.deleteApartment(
          housingCompanyId: housingCompanyId, apartmentId: apartmentId);
      return ResultSuccess(Apartment.modelToEntity(apartmentModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Apartment>> editApartmentInfo(
      {required String housingCompanyId,
      required String apartmentId,
      String? building,
      String? houseCode}) async {
    try {
      final apartmentModel = await apartmentDataSource.editApartmentInfo(
          housingCompanyId: housingCompanyId,
          apartmentId: apartmentId,
          building: building,
          houseCode: houseCode);
      return ResultSuccess(Apartment.modelToEntity(apartmentModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Apartment>> joinApartment({
    required String invitationCode,
  }) async {
    try {
      final apartmentModel = await apartmentDataSource.joinApartment(
        invitationCode: invitationCode,
      );
      return ResultSuccess(Apartment.modelToEntity(apartmentModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<StorageItem>>> addApartmentDocuments(
      {required List<String> storageItems,
      required String housingCompanyId,
      required String apartmentId,
      String? type}) async {
    try {
      final documentListModel = await apartmentDataSource.addApartmentDocuments(
          storageItems: storageItems,
          housingCompanyId: housingCompanyId,
          apartmentId: apartmentId,
          type: type);
      return ResultSuccess(
          documentListModel.map((e) => StorageItem.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<StorageItem>> getApartmentDocument(
      {required String documentId,
      required String housingCompanyId,
      required String apartmentId}) async {
    try {
      final documentModel = await apartmentDataSource.getApartmentDocument(
        documentId: documentId,
        housingCompanyId: housingCompanyId,
        apartmentId: apartmentId,
      );
      return ResultSuccess(StorageItem.modelToEntity(documentModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<StorageItem>>> getApartmentDocuments(
      {required String housingCompanyId,
      required String apartmentId,
      int? limit,
      int? lastCreatedOn,
      String? type}) async {
    try {
      final documentListModel = await apartmentDataSource.getApartmentDocuments(
          housingCompanyId: housingCompanyId,
          apartmentId: apartmentId,
          lastCreatedOn: lastCreatedOn,
          limit: limit,
          type: type);
      return ResultSuccess(
          documentListModel.map((e) => StorageItem.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<StorageItem>> updateApartmentDocument(
      {required String documentId,
      required String housingCompanyId,
      required String apartmentId,
      bool? isDeleted,
      String? name}) async {
    try {
      final documentModel = await apartmentDataSource.getApartmentDocument(
        documentId: documentId,
        housingCompanyId: housingCompanyId,
        apartmentId: apartmentId,
      );
      return ResultSuccess(StorageItem.modelToEntity(documentModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

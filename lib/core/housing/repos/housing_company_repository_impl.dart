import 'package:priorli/core/housing/data/housing_company_data_source.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';
import 'package:priorli/core/user/entities/user.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../entities/ui.dart';

class HousingCompanyRepositoryImpl extends HousingCompanyRepository {
  final HousingCompanyDataSource housingCompanyDataSource;

  HousingCompanyRepositoryImpl({
    required this.housingCompanyDataSource,
  });
  @override
  Future<Result<HousingCompany>> createHousingCompany(
      {required String name, required String countryCode}) async {
    try {
      final housingCompanyModel = await housingCompanyDataSource
          .createHousingCompany(name: name, countryCode: countryCode);
      return ResultSuccess(HousingCompany.modelToEntity(housingCompanyModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<HousingCompany>>> getHousingCompanies() async {
    try {
      final housingCompanyListModel =
          await housingCompanyDataSource.getUserHousingCompanies();

      return ResultSuccess(housingCompanyListModel
          .map((e) => HousingCompany.modelToEntity(e))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<HousingCompany>> updateHousingCompanyInfo(
      {String? name,
      required String housingCompanyId,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      double? lat,
      double? lng,
      String? city,
      UI? ui,
      String? coverImageStorageLink,
      String? logoStorageLink,
      String? countryCode}) async {
    try {
      final housingCompanyModel =
          await housingCompanyDataSource.updateHousingCompanyInfo(
              name: name,
              housingCompanyId: housingCompanyId,
              streetAddress1: streetAddress1,
              streetAddress2: streetAddress2,
              postalCode: postalCode,
              lat: lat,
              lng: lng,
              ui: ui,
              coverImageStorageLink: coverImageStorageLink,
              logoStorageLink: logoStorageLink,
              city: city,
              countryCode: countryCode);
      return ResultSuccess(HousingCompany.modelToEntity(housingCompanyModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<HousingCompany>> getHousingCompany(
      {required String housingCompanyId}) async {
    try {
      final housingCompanyModel = await housingCompanyDataSource
          .getHousingCompany(housingCompanyId: housingCompanyId);
      return ResultSuccess(HousingCompany.modelToEntity(housingCompanyModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<HousingCompany>> deleteHousingCompany(
      {required String housingCompanyId}) async {
    try {
      final housingCompanyModel = await housingCompanyDataSource
          .deleteHousingCompany(housingCompanyId: housingCompanyId);
      return ResultSuccess(HousingCompany.modelToEntity(housingCompanyModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<StorageItem>>> addCompanyDocuments(
      {required List<String> storageItems,
      required String housingCompanyId,
      String? type}) async {
    try {
      final documentListModel =
          await housingCompanyDataSource.addCompanyDocuments(
              storageItems: storageItems,
              housingCompanyId: housingCompanyId,
              type: type);
      return ResultSuccess(
          documentListModel.map((e) => StorageItem.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<StorageItem>> getCompanyDocument(
      {required String documentId, required String housingCompanyId}) async {
    try {
      final documentModel = await housingCompanyDataSource.getCompanyDocument(
          housingCompanyId: housingCompanyId, documentId: documentId);
      return ResultSuccess(StorageItem.modelToEntity(documentModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<StorageItem>>> getCompanyDocuments({
    required String housingCompanyId,
    String? type,
    int? limit,
    int? lastCreatedOn,
  }) async {
    try {
      final documentListModel =
          await housingCompanyDataSource.getCompanyDocuments(
              housingCompanyId: housingCompanyId,
              type: type,
              lastCreatedOn: lastCreatedOn,
              limit: limit);
      return ResultSuccess(
          documentListModel.map((e) => StorageItem.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<StorageItem>> updateCompanyDocument(
      {required String documentId,
      required String housingCompanyId,
      bool? isDeleted,
      String? name}) async {
    try {
      final documentModel =
          await housingCompanyDataSource.updateCompanyDocument(
              housingCompanyId: housingCompanyId,
              documentId: documentId,
              isDeleted: isDeleted,
              name: name);
      return ResultSuccess(StorageItem.modelToEntity(documentModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<User>>> getCompanyUsers(
      {required String housingCompanyId}) async {
    try {
      final userModels = await housingCompanyDataSource.getCompanyUsers(
        housingCompanyId: housingCompanyId,
      );
      return ResultSuccess(
          userModels.map((e) => User.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<User>> addHousingCompanyManager(
      {required String housingCompanyId,
      required String email,
      String? firstName,
      String? lastName,
      String? phoneNumber}) async {
    try {
      final userModel = await housingCompanyDataSource.addHousingCompanyManager(
          housingCompanyId: housingCompanyId,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber);
      return ResultSuccess(User.modelToEntity(userModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<User>>> getHousingCompanyManagers(
      {required String companyId}) async {
    try {
      final userModels =
          await housingCompanyDataSource.getHousingCompanyManagers(
        companyId: companyId,
      );
      return ResultSuccess(
          userModels.map((e) => User.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<HousingCompany>>> adminGetCompanies(
      {required int lastCreatedOn, required int limit}) async {
    try {
      final housingCompanyListModel = await housingCompanyDataSource
          .adminGetCompanies(lastCreatedOn: lastCreatedOn, limit: limit);

      return ResultSuccess(housingCompanyListModel
          .map((e) => HousingCompany.modelToEntity(e))
          .toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

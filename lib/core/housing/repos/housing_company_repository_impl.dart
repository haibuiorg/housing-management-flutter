import 'package:priorli/core/housing/data/housing_company_data_source.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';

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
      {required String name}) async {
    try {
      final housingCompanyModel =
          await housingCompanyDataSource.createHousingCompany(name: name);
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
}

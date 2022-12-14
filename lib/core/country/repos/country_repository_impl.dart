import 'package:priorli/core/country/data/country_data_source.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/country/repos/country_repository.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';

class CountryRepositoryImpl extends CountryRepository {
  final CountryDataSource countryDataSource;

  CountryRepositoryImpl({required this.countryDataSource});
  @override
  Future<Result<Country>> getCountryData({required String countryId}) async {
    try {
      final countryModel =
          await countryDataSource.getCountryData(countryId: countryId);
      return ResultSuccess(Country.modelToEntity(countryModel));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<Country>>> getSupportCountries() async {
    try {
      final supportedCountryModels =
          await countryDataSource.getSupportCountries();

      return ResultSuccess(
          supportedCountryModels.map((e) => Country.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/core/country/repos/country_repository.dart';

class GetCountryData extends UseCase<Country, GetCountryDataParams> {
  final CountryRepository countryRepository;

  GetCountryData({required this.countryRepository});
  @override
  Future<Result<Country>> call(GetCountryDataParams params) {
    return countryRepository.getCountryData(countryId: params.id);
  }
}

class GetCountryDataParams extends Equatable {
  final String id;

  const GetCountryDataParams({required this.id});

  @override
  List<Object?> get props => [id];
}

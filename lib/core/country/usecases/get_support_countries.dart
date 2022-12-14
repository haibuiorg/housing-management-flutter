import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/country/entities/country.dart';
import 'package:priorli/core/country/repos/country_repository.dart';

class GetSupportCountries extends UseCase<List<Country>, NoParams> {
  final CountryRepository countryRepository;

  GetSupportCountries({required this.countryRepository});
  @override
  Future<Result<List<Country>>> call(NoParams params) {
    return countryRepository.getSupportCountries();
  }
}

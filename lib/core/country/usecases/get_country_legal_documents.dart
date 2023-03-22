import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/base/usecase.dart';
import 'package:priorli/core/country/entities/legal_document.dart';
import 'package:priorli/core/country/repos/country_repository.dart';

class GetCountryLegalDocuments
    extends UseCase<List<LegalDocument>, GetCountryLegalDocumentDataParams> {
  final CountryRepository countryRepository;

  GetCountryLegalDocuments({required this.countryRepository});

  @override
  Future<Result<List<LegalDocument>>> call(
      GetCountryLegalDocumentDataParams params) {
    return countryRepository.getCountryLegalDocuments(
        countryCode: params.countryCode);
  }
}

class GetCountryLegalDocumentDataParams extends Equatable {
  final String countryCode;

  const GetCountryLegalDocumentDataParams({required this.countryCode});

  @override
  List<Object?> get props => [countryCode];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';

class GetCompanyDocument
    extends UseCase<StorageItem, GetCompanyDocumentParams> {
  final HousingCompanyRepository housingCompanyRepository;

  GetCompanyDocument({required this.housingCompanyRepository});
  @override
  Future<Result<StorageItem>> call(GetCompanyDocumentParams params) {
    return housingCompanyRepository.getCompanyDocument(
      housingCompanyId: params.housingCompanyId,
      documentId: params.documentId,
    );
  }
}

class GetCompanyDocumentParams extends Equatable {
  final String housingCompanyId;
  final String documentId;

  const GetCompanyDocumentParams({
    required this.housingCompanyId,
    required this.documentId,
  });

  @override
  List<Object?> get props => [housingCompanyId, documentId];
}

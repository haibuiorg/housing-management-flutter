import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';

class UpdateCompanyDocument
    extends UseCase<StorageItem, UpdateCompanyDocumentParams> {
  final HousingCompanyRepository housingCompanyRepository;

  UpdateCompanyDocument({required this.housingCompanyRepository});
  @override
  Future<Result<StorageItem>> call(UpdateCompanyDocumentParams params) {
    return housingCompanyRepository.updateCompanyDocument(
        housingCompanyId: params.housingCompanyId,
        documentId: params.documentId,
        isDeleted: params.isDeleted,
        name: params.name);
  }
}

class UpdateCompanyDocumentParams extends Equatable {
  final String housingCompanyId;
  final String documentId;
  final String? name;
  final bool? isDeleted;

  const UpdateCompanyDocumentParams(
      {required this.housingCompanyId,
      required this.documentId,
      this.name,
      this.isDeleted});

  @override
  List<Object?> get props => [housingCompanyId, documentId, name, isDeleted];
}

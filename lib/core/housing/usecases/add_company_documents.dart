import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';

class AddCompanyDocuments
    extends UseCase<List<StorageItem>, AddCompanyDocumentParams> {
  final HousingCompanyRepository housingCompanyRepository;

  AddCompanyDocuments({required this.housingCompanyRepository});
  @override
  Future<Result<List<StorageItem>>> call(AddCompanyDocumentParams params) {
    return housingCompanyRepository.addCompanyDocuments(
        housingCompanyId: params.housingCompanyId,
        storageItems: params.storageItems,
        type: params.type);
  }
}

class AddCompanyDocumentParams extends Equatable {
  final String housingCompanyId;
  final List<String> storageItems;
  final String? type;

  const AddCompanyDocumentParams(
      {required this.housingCompanyId, required this.storageItems, this.type});

  @override
  List<Object?> get props => [housingCompanyId, storageItems, type];
}

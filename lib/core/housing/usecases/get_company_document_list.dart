import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/repos/housing_company_repository.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';

class GetCompanyDocumentList
    extends UseCase<List<StorageItem>, GetCompanyDocumentListParams> {
  final HousingCompanyRepository housingCompanyRepository;

  GetCompanyDocumentList({required this.housingCompanyRepository});
  @override
  Future<Result<List<StorageItem>>> call(GetCompanyDocumentListParams params) {
    return housingCompanyRepository.getCompanyDocuments(
        housingCompanyId: params.housingCompanyId,
        type: params.type,
        limit: params.limit,
        lastCreatedOn: params.lastCreatedOn);
  }
}

class GetCompanyDocumentListParams extends Equatable {
  final String housingCompanyId;
  final String? type;
  final int? limit;
  final int? lastCreatedOn;

  const GetCompanyDocumentListParams(
      {required this.housingCompanyId,
      this.type,
      this.lastCreatedOn,
      this.limit});

  @override
  List<Object?> get props => [housingCompanyId, type, lastCreatedOn, limit];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/apartment_repository.dart';

class GetApartmentDocumentList
    extends UseCase<List<StorageItem>, GetApartmentDocumentListParams> {
  final ApartmentRepository apartmentRepository;

  GetApartmentDocumentList({required this.apartmentRepository});
  @override
  Future<Result<List<StorageItem>>> call(
      GetApartmentDocumentListParams params) {
    return apartmentRepository.getApartmentDocuments(
        housingCompanyId: params.housingCompanyId,
        apartmentId: params.apartmentId,
        lastCreatedOn: params.lastCreatedOn,
        limit: params.limit,
        type: params.type);
  }
}

class GetApartmentDocumentListParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  final String? type;
  final int? limit;
  final int? lastCreatedOn;

  const GetApartmentDocumentListParams(
      {required this.housingCompanyId,
      required this.apartmentId,
      this.type,
      this.lastCreatedOn,
      this.limit});

  @override
  List<Object?> get props =>
      [housingCompanyId, apartmentId, type, lastCreatedOn, limit];
}

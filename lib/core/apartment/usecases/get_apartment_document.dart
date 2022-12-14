import 'package:equatable/equatable.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/apartment_repository.dart';

class GetApartmentDocument
    extends UseCase<StorageItem, GetApartmentDocumentParams> {
  final ApartmentRepository apartmentRepository;

  GetApartmentDocument({required this.apartmentRepository});
  @override
  Future<Result<StorageItem>> call(GetApartmentDocumentParams params) {
    return apartmentRepository.getApartmentDocument(
        housingCompanyId: params.housingCompanyId,
        apartmentId: params.apartmentId,
        documentId: params.documentId);
  }
}

class GetApartmentDocumentParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  final String documentId;

  const GetApartmentDocumentParams(
      {required this.housingCompanyId,
      required this.apartmentId,
      required this.documentId});

  @override
  List<Object?> get props => [housingCompanyId, apartmentId, documentId];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/apartment_repository.dart';

class UpdateApartmentDocument
    extends UseCase<StorageItem, UpdateApartmentDocumentParams> {
  final ApartmentRepository apartmentRepository;

  UpdateApartmentDocument({required this.apartmentRepository});
  @override
  Future<Result<StorageItem>> call(UpdateApartmentDocumentParams params) {
    return apartmentRepository.updateApartmentDocument(
        housingCompanyId: params.housingCompanyId,
        apartmentId: params.apartmentId,
        documentId: params.documentId,
        isDeleted: params.isDeleted,
        name: params.name);
  }
}

class UpdateApartmentDocumentParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  final String documentId;
  final String? name;
  final bool? isDeleted;

  const UpdateApartmentDocumentParams(
      {required this.housingCompanyId,
      required this.apartmentId,
      required this.documentId,
      this.name,
      this.isDeleted});

  @override
  List<Object?> get props =>
      [housingCompanyId, apartmentId, documentId, isDeleted, name];
}

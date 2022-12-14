import 'package:equatable/equatable.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/apartment_repository.dart';

class AddApartmentDocuments
    extends UseCase<List<StorageItem>, AddApartmentDocumentParams> {
  final ApartmentRepository apartmentRepository;

  AddApartmentDocuments({required this.apartmentRepository});
  @override
  Future<Result<List<StorageItem>>> call(AddApartmentDocumentParams params) {
    return apartmentRepository.addApartmentDocuments(
        housingCompanyId: params.housingCompanyId,
        apartmentId: params.apartmentId,
        storageItems: params.storageItems,
        type: params.type);
  }
}

class AddApartmentDocumentParams extends Equatable {
  final String housingCompanyId;
  final String apartmentId;
  final List<String> storageItems;
  final String? type;

  const AddApartmentDocumentParams(
      {required this.housingCompanyId,
      required this.apartmentId,
      required this.storageItems,
      this.type});

  @override
  List<Object?> get props =>
      [housingCompanyId, apartmentId, storageItems, type];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

class DocumentScreenState extends Equatable {
  final String? companyId;
  final String? apartmentId;
  final StorageItem? document;

  const DocumentScreenState({this.companyId, this.apartmentId, this.document});

  DocumentScreenState copyWith({
    String? companyId,
    String? apartmentId,
    StorageItem? document,
  }) =>
      DocumentScreenState(
          companyId: companyId ?? this.companyId,
          apartmentId: apartmentId ?? this.apartmentId,
          document: document ?? this.document);

  @override
  List<Object?> get props => [companyId, apartmentId, document];
}

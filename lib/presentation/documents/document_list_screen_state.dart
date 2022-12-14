import 'package:equatable/equatable.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

class DocumentListScreenState extends Equatable {
  final String? companyId;
  final String? apartmentId;
  final List<StorageItem>? documentList;

  const DocumentListScreenState(
      {this.companyId, this.apartmentId, this.documentList});

  DocumentListScreenState copyWith({
    String? companyId,
    String? apartmentId,
    List<StorageItem>? documentList,
  }) =>
      DocumentListScreenState(
          companyId: companyId ?? this.companyId,
          apartmentId: apartmentId ?? this.apartmentId,
          documentList: documentList ?? this.documentList);

  @override
  List<Object?> get props => [companyId, apartmentId, documentList];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

class DocumentListScreenState extends Equatable {
  final String? companyId;
  final String? apartmentId;
  final bool? addDocument;
  final List<StorageItem>? documentList;

  const DocumentListScreenState(
      {this.companyId, this.apartmentId, this.documentList, this.addDocument});

  DocumentListScreenState copyWith({
    String? companyId,
    String? apartmentId,
    bool? addDocument,
    List<StorageItem>? documentList,
  }) =>
      DocumentListScreenState(
          addDocument: addDocument ?? this.addDocument,
          companyId: companyId ?? this.companyId,
          apartmentId: apartmentId ?? this.apartmentId,
          documentList: documentList ?? this.documentList);

  @override
  List<Object?> get props =>
      [companyId, apartmentId, documentList, addDocument];
}

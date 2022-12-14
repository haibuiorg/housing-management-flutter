import 'package:bloc/bloc.dart';
import 'package:priorli/core/apartment/usecases/add_apartment_documents.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document_list.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/usecases/add_company_documents.dart';
import 'package:priorli/core/housing/usecases/get_company_document.dart';
import 'package:priorli/core/housing/usecases/get_company_document_list.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';
import 'package:priorli/presentation/documents/document_list_screen_state.dart';

class DocumentListScreenCubit extends Cubit<DocumentListScreenState> {
  final AddCompanyDocuments _addCompanyDocuments;
  final AddApartmentDocuments _addApartmentDocuments;
  final GetApartmentDocumentList _getApartmentDocumentList;
  final GetCompanyDocumentList _getCompanyDocumentList;
  final GetApartmentDocument _getApartmentDocument;
  final GetCompanyDocument _getCompanyDocument;

  DocumentListScreenCubit(
      this._addCompanyDocuments,
      this._addApartmentDocuments,
      this._getApartmentDocumentList,
      this._getCompanyDocumentList,
      this._getApartmentDocument,
      this._getCompanyDocument)
      : super(const DocumentListScreenState());

  Future<void> init(String? companyId, String? apartmentId) async {
    if (apartmentId?.isNotEmpty == true && companyId?.isNotEmpty == true) {
      emit(state.copyWith(companyId: companyId, apartmentId: apartmentId));
      final documentListResult = await _getApartmentDocumentList(
          GetApartmentDocumentListParams(
              housingCompanyId: companyId!, apartmentId: apartmentId!));
      if (documentListResult is ResultSuccess<List<StorageItem>>) {
        emit(state.copyWith(documentList: documentListResult.data));
      }
    } else if (companyId?.isNotEmpty == true) {
      emit(state.copyWith(companyId: companyId));
      final documentListResult =
          await _getCompanyDocumentList(GetCompanyDocumentListParams(
        housingCompanyId: companyId!,
      ));
      if (documentListResult is ResultSuccess<List<StorageItem>>) {
        emit(state.copyWith(documentList: documentListResult.data));
      }
    }
  }

  Future<void> uploadNewFile(List<String> files) async {
    if (state.apartmentId != null && state.companyId != null) {
      final addApartmentDocumentResult = await _addApartmentDocuments(
          AddApartmentDocumentParams(
              housingCompanyId: state.companyId ?? '',
              apartmentId: state.apartmentId ?? '',
              storageItems: files));
      if (addApartmentDocumentResult is ResultSuccess<List<StorageItem>>) {
        final List<StorageItem> currentList =
            List.from(state.documentList ?? []);
        currentList.insertAll(0, addApartmentDocumentResult.data);
        emit(state.copyWith(documentList: currentList));
      }
    } else if (state.companyId != null) {
      final addCompanyDocumentResult = await _addCompanyDocuments(
          AddCompanyDocumentParams(
              housingCompanyId: state.companyId ?? '', storageItems: files));
      if (addCompanyDocumentResult is ResultSuccess<List<StorageItem>>) {
        final List<StorageItem> currentList =
            List.from(state.documentList ?? []);
        currentList.insertAll(0, addCompanyDocumentResult.data);
        emit(state.copyWith(documentList: currentList));
      }
    }
  }

  Future<StorageItem?> getDocument(String id) async {
    if (state.apartmentId != null && state.companyId != null) {
      final getApartmentDocumentResult = await _getApartmentDocument(
          GetApartmentDocumentParams(
              housingCompanyId: state.companyId ?? '',
              apartmentId: state.apartmentId ?? '',
              documentId: id));
      if (getApartmentDocumentResult is ResultSuccess<StorageItem>) {
        return getApartmentDocumentResult.data;
      }
    } else if (state.companyId != null) {
      final getCompanyDocumentResult = await _getCompanyDocument(
          GetCompanyDocumentParams(
              housingCompanyId: state.companyId ?? '', documentId: id));
      if (getCompanyDocumentResult is ResultSuccess<StorageItem>) {
        return getCompanyDocumentResult.data;
      }
    }
    return null;
  }
}

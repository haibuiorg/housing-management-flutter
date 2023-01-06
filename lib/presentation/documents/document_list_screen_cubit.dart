import 'package:bloc/bloc.dart';
import 'package:priorli/core/apartment/usecases/add_apartment_documents.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document_list.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/add_company_documents.dart';
import 'package:priorli/core/housing/usecases/get_company_document.dart';
import 'package:priorli/core/housing/usecases/get_company_document_list.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';
import 'package:priorli/presentation/documents/document_list_screen_state.dart';

class DocumentListScreenCubit extends Cubit<DocumentListScreenState> {
  final AddCompanyDocuments _addCompanyDocuments;
  final AddApartmentDocuments _addApartmentDocuments;
  final GetApartmentDocumentList _getApartmentDocumentList;
  final GetCompanyDocumentList _getCompanyDocumentList;
  final GetApartmentDocument _getApartmentDocument;
  final GetCompanyDocument _getCompanyDocument;
  final GetHousingCompany _getHousingCompany;

  DocumentListScreenCubit(
      this._addCompanyDocuments,
      this._addApartmentDocuments,
      this._getApartmentDocumentList,
      this._getCompanyDocumentList,
      this._getApartmentDocument,
      this._getCompanyDocument,
      this._getHousingCompany)
      : super(const DocumentListScreenState());

  Future<void> init(String? companyId, String? apartmentId) async {
    if (apartmentId?.isNotEmpty == true && companyId?.isNotEmpty == true) {
      emit(state.copyWith(companyId: companyId, apartmentId: apartmentId));
      final documentListResult = await _getApartmentDocumentList(
          GetApartmentDocumentListParams(
              housingCompanyId: companyId!, apartmentId: apartmentId!));
      if (documentListResult is ResultSuccess<List<StorageItem>>) {
        emit(state.copyWith(
            documentList: documentListResult.data, addDocument: true));
      }
    } else if (companyId?.isNotEmpty == true) {
      getCompanyData(companyId!);
      emit(state.copyWith(companyId: companyId));
      final documentListResult =
          await _getCompanyDocumentList(GetCompanyDocumentListParams(
        housingCompanyId: companyId,
      ));
      if (documentListResult is ResultSuccess<List<StorageItem>>) {
        emit(state.copyWith(documentList: documentListResult.data));
      }
    }
  }

  Future<void> getCompanyData(String companyId) async {
    final companytResult = await _getHousingCompany(GetHousingCompanyParams(
      housingCompanyId: companyId,
    ));
    if (companytResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(addDocument: companytResult.data.isUserManager));
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

  Future<void> loadMore() async {
    if (state.apartmentId != null && state.companyId != null) {
      final documentListResult = await _getApartmentDocumentList(
          GetApartmentDocumentListParams(
              lastCreatedOn: state.documentList?.last.createdOn,
              housingCompanyId: state.companyId!,
              apartmentId: state.apartmentId!));
      if (documentListResult is ResultSuccess<List<StorageItem>>) {
        final List<StorageItem> list = List.from(state.documentList ?? []);
        list.addAll(documentListResult.data);
        emit(state.copyWith(documentList: list));
      }
    } else if (state.companyId != null) {
      final documentListResult =
          await _getCompanyDocumentList(GetCompanyDocumentListParams(
        lastCreatedOn: state.documentList?.last.createdOn,
        housingCompanyId: state.companyId!,
      ));
      if (documentListResult is ResultSuccess<List<StorageItem>>) {
        final List<StorageItem> list = List.from(state.documentList ?? []);
        list.addAll(documentListResult.data);
        emit(state.copyWith(documentList: list));
      }
    }
  }
}

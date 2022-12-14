import 'package:bloc/bloc.dart';
import 'package:priorli/core/apartment/usecases/get_apartment_document.dart';
import 'package:priorli/core/housing/usecases/get_company_document.dart';

import 'document_screen_state.dart';

class DocumentScreenCubit extends Cubit<DocumentScreenState> {
  final GetApartmentDocument _getApartmentDocument;
  final GetCompanyDocument _getCompanyDocument;

  DocumentScreenCubit(this._getApartmentDocument, this._getCompanyDocument)
      : super(const DocumentScreenState());
}

import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/invoice/usecases/get_company_invoices.dart';
import 'package:priorli/core/invoice/usecases/get_invoice_detail.dart';
import 'package:priorli/core/invoice/usecases/get_personal_invoices.dart';
import 'package:priorli/core/invoice/usecases/send_invoice_manually.dart';
import 'package:priorli/presentation/invoice/invoice_list_state.dart';

import '../../core/invoice/entities/invoice.dart';

class InvoiceListCubit extends Cubit<InvoiceListState> {
  final GetHousingCompany _getHousingCompany;
  final GetPersonalInvoices _getPersonalInvoices;
  final GetCompanyInvoices _getCompanyInvoices;
  final GetInvoiceDetail _getInvoiceDetail;
  final SendInvoiceManually _sendInvoiceManually;
  InvoiceListCubit(
      this._getHousingCompany,
      this._getPersonalInvoices,
      this._getCompanyInvoices,
      this._getInvoiceDetail,
      this._sendInvoiceManually)
      : super(const InvoiceListState());
  Future<void> init(
      {String? companyId,
      String? invoiceGroupId,
      bool isPersonal = false}) async {
    if (!isPersonal) {
      if (companyId == null) {
        return;
      }
      final companyResult = await _getHousingCompany(
          GetHousingCompanyParams(housingCompanyId: companyId));
      if (companyResult is! ResultSuccess<HousingCompany> ||
          !companyResult.data.isUserManager) {
        return;
      }
      final invoiceResult = await _getCompanyInvoices(GetInvoicesParams(
          companyId: companyId,
          limit: 10,
          lastCreatedOn: DateTime.now().millisecondsSinceEpoch,
          groupId: invoiceGroupId));
      if (invoiceResult is ResultSuccess<List<Invoice>>) {
        emit(
            state.copyWith(invoiceList: invoiceResult.data, isPersonal: false));
      }
      return;
    }
    final invoiceResult = await _getPersonalInvoices(GetInvoicesParams(
        companyId: companyId,
        limit: 10,
        lastCreatedOn: DateTime.now().millisecondsSinceEpoch,
        groupId: invoiceGroupId));
    if (invoiceResult is ResultSuccess<List<Invoice>>) {
      emit(state.copyWith(invoiceList: invoiceResult.data, isPersonal: true));
    }
  }

  Future<Invoice?> getInvoiceDetail(String invoiceId) async {
    final getInvoiceDetailResult =
        await _getInvoiceDetail(InvoiceRequestParams(invoiceId: invoiceId));
    if (getInvoiceDetailResult is ResultSuccess<Invoice>) {
      return getInvoiceDetailResult.data;
    }
    return null;
  }

  Future<void> resendInvoice(Invoice invoice, String text) async {
    final sendInvoiceManuallyResult = await _sendInvoiceManually(
        SendInvoiceManuallyParams(invoiceId: invoice.id, emails: [text]));
    if (sendInvoiceManuallyResult is ResultSuccess<Invoice>) {}
  }

  void clearMessage() {
    emit(state.copyWith(message: null));
  }
}

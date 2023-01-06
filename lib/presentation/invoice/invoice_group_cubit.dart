import 'package:bloc/bloc.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';
import 'package:priorli/core/invoice/entities/invoice.dart';
import 'package:priorli/core/invoice/entities/invoice_group.dart';
import 'package:priorli/core/invoice/usecases/get_company_invoices.dart';
import 'package:priorli/core/invoice/usecases/get_invoice_groups.dart';
import 'package:priorli/presentation/invoice/invoice_group_state.dart';

class InvoiceGroupCubit extends Cubit<InvoiceGroupState> {
  final GetInvoiceGroups _getInvoiceGroups;
  final GetHousingCompany _getHousingCompany;
  InvoiceGroupCubit(this._getInvoiceGroups, this._getHousingCompany)
      : super(const InvoiceGroupState());

  Future<void> init(String companyId) async {
    final getCompanyResult = await _getHousingCompany(
        GetHousingCompanyParams(housingCompanyId: companyId));
    if (getCompanyResult is ResultSuccess<HousingCompany>) {
      emit(state.copyWith(company: getCompanyResult.data));
    }
    if (state.company?.isUserManager != true) {
      return;
    }
    final getInvoiceResult = await _getInvoiceGroups(
        GetInvoiceGroupParams(limit: state.limit, companyId: companyId));
    if (getInvoiceResult is ResultSuccess<List<InvoiceGroup>>) {
      emit(state.copyWith(invoiceGroupList: getInvoiceResult.data));
    }
  }

  Future<void> loadMore() async {
    if (state.company?.isUserManager != true) {
      return;
    }
    final getInvoiceResult = await _getInvoiceGroups(GetInvoiceGroupParams(
        limit: state.limit,
        lastCreatedOn: state.invoiceGroupList?.last.createdOn,
        companyId: state.company?.id ?? ''));
    if (getInvoiceResult is ResultSuccess<List<InvoiceGroup>>) {
      final newInvoices = List.from(state.invoiceGroupList ?? []);
      newInvoices.addAll(getInvoiceResult.data);
      emit(state.copyWith(invoiceGroupList: getInvoiceResult.data));
    }
  }
}

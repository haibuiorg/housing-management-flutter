import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/invoice/entities/invoice_group.dart';

class InvoiceGroupState extends Equatable {
  final List<InvoiceGroup>? invoiceGroupList;
  final HousingCompany? company;
  final int limit;

  const InvoiceGroupState(
      {this.invoiceGroupList, this.limit = 10, this.company});

  InvoiceGroupState copyWith(
          {List<InvoiceGroup>? invoiceGroupList,
          int? limit,
          HousingCompany? company}) =>
      InvoiceGroupState(
          company: company ?? this.company,
          invoiceGroupList: invoiceGroupList ?? this.invoiceGroupList,
          limit: limit ?? this.limit);
  @override
  List<Object?> get props => [limit, invoiceGroupList, company];
}

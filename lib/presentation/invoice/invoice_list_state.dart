import 'package:equatable/equatable.dart';

import '../../core/invoice/entities/invoice.dart';

class InvoiceListState extends Equatable {
  final List<Invoice>? invoiceList;
  final bool? isPersonal;
  final int limit;

  const InvoiceListState({this.invoiceList, this.isPersonal, this.limit = 10});

  InvoiceListState copyWith(
          {List<Invoice>? invoiceList, bool? isPersonal, int? limit}) =>
      InvoiceListState(
          limit: limit ?? this.limit,
          invoiceList: invoiceList ?? this.invoiceList,
          isPersonal: isPersonal ?? this.isPersonal);

  @override
  List<Object?> get props => [isPersonal, invoiceList, limit];
}

import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';

import '../../base/usecase.dart';
import '../entities/invoice.dart';
import '../repos/invoice_repository.dart';

class SendInvoiceManually extends UseCase<Invoice, SendInvoiceManuallyParams> {
  final InvoiceRepository invoiceRepository;

  SendInvoiceManually({required this.invoiceRepository});

  @override
  Future<Result<Invoice>> call(SendInvoiceManuallyParams params) async {
    return await invoiceRepository.sendInvoiceManually(
      invoiceId: params.invoiceId,
      emails: params.emails,
      name: params.name,
      streetAddress1: params.streetAddress1,
      streetAddress2: params.streetAddress2,
      postalCode: params.postalCode,
      city: params.city,
      countryCode: params.countryCode,
    );
  }
}

class SendInvoiceManuallyParams extends Equatable {
  final String invoiceId;
  final List<String> emails;
  final String? name;
  final String? streetAddress1;
  final String? streetAddress2;
  final String? postalCode;
  final String? city;
  final String? countryCode;

  const SendInvoiceManuallyParams({
    required this.invoiceId,
    required this.emails,
    this.name,
    this.streetAddress1,
    this.streetAddress2,
    this.postalCode,
    this.city,
    this.countryCode,
  });

  @override
  List<Object?> get props => [
        invoiceId,
        emails,
        name,
        streetAddress1,
        streetAddress2,
        postalCode,
        city,
        countryCode
      ];
}

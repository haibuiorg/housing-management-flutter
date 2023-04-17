import 'package:priorli/core/invoice/entities/invoice_group.dart';
import 'package:priorli/core/invoice/entities/invoice.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/invoice/repos/invoice_repository.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../data/invoice_data_source.dart';
import '../entities/invoice_status.dart';
import '../usecases/create_new_invoices.dart';

class InvoiceRepositoryImpl extends InvoiceRepository {
  final InvoiceDataSource invoiceRemoteDataSource;

  InvoiceRepositoryImpl({required this.invoiceRemoteDataSource});
  @override
  Future<Result<List<Invoice>>> createNewInvoices(
      {required String companyId,
      required List<String> receiverIds,
      required String invoiceName,
      required String bankAccountId,
      required int paymentDate,
      required List<InvoiceItemParams> items,
      bool? issueExternalInvoice,
      required bool sendEmail}) async {
    try {
      final models = await invoiceRemoteDataSource.createNewInvoices(
          companyId: companyId,
          receiverIds: receiverIds,
          invoiceName: invoiceName,
          bankAccountId: bankAccountId,
          paymentDate: paymentDate,
          issueExternalInvoice: issueExternalInvoice,
          items: items,
          sendEmail: sendEmail);
      return ResultSuccess(
          models.map((e) => Invoice.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Invoice>> deleteInvoice({required String invoiceId}) async {
    try {
      final model =
          await invoiceRemoteDataSource.deleteInvoice(invoiceId: invoiceId);
      return ResultSuccess(Invoice.modelToEntity(model));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Invoice>> getInvoiceDetail({required String invoiceId}) async {
    try {
      final model =
          await invoiceRemoteDataSource.getInvoiceDetail(invoiceId: invoiceId);
      return ResultSuccess(Invoice.modelToEntity(model));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<Invoice>>> getInvoices(
      {InvoiceStatus? status,
      int? limit,
      int? lastCreatedOn,
      bool? personal,
      String? groupId,
      String? companyId}) async {
    try {
      final models = await invoiceRemoteDataSource.getInvoices(
          companyId: companyId,
          status: status,
          lastCreatedOn: lastCreatedOn,
          personal: personal,
          groupId: groupId,
          limit: limit);
      return ResultSuccess(
          models.map((e) => Invoice.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<InvoiceGroup>>> getInvoiceGroups(
      {String? companyId,
      bool? includeDeleted,
      int? limit,
      int? lastCreatedOn}) async {
    try {
      final models = await invoiceRemoteDataSource.getInvoiceGroups(
          companyId: companyId,
          includeDeleted: includeDeleted,
          lastCreatedOn: lastCreatedOn,
          limit: limit);
      return ResultSuccess(
          models.map((e) => InvoiceGroup.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<Invoice>> sendInvoiceManually(
      {required String invoiceId,
      required List<String> emails,
      String? name,
      String? streetAddress1,
      String? streetAddress2,
      String? postalCode,
      String? city,
      String? countryCode}) async {
    try {
      final model = await invoiceRemoteDataSource.sendInvoiceManually(
          invoiceId: invoiceId,
          emails: emails,
          name: name,
          streetAddress1: streetAddress1,
          streetAddress2: streetAddress2,
          postalCode: postalCode,
          city: city,
          countryCode: countryCode);
      return ResultSuccess(Invoice.modelToEntity(model));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<PaymentProductItem>> addPaymentProductItem(
      {required String companyId,
      required String name,
      required String description,
      required double price,
      required double taxPercentage}) async {
    try {
      final model = await invoiceRemoteDataSource.addPaymentProductItem(
          companyId: companyId,
          name: name,
          description: description,
          price: price,
          taxPercentage: taxPercentage);
      return ResultSuccess(PaymentProductItem.modelToEntity(model));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<bool>> deletePaymentProductItem(
      {required String id, required String companyId}) async {
    try {
      final model = await invoiceRemoteDataSource.deletePaymentProductItem(
          id: id, companyId: companyId);
      return ResultSuccess(model);
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }

  @override
  Future<Result<List<PaymentProductItem>>> getPaymentProductItems(
      {required String companyId}) async {
    try {
      final models = await invoiceRemoteDataSource.getPaymentProductItems(
          companyId: companyId);
      return ResultSuccess(
          models.map((e) => PaymentProductItem.modelToEntity(e)).toList());
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

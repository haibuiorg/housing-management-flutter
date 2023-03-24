import 'package:priorli/core/invoice/entities/invoice_group.dart';
import 'package:priorli/core/invoice/entities/invoice_item.dart';
import 'package:priorli/core/invoice/entities/invoice.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/invoice/models/invoice_item_model.dart';
import 'package:priorli/core/invoice/repos/invoice_repository.dart';

import '../../base/exceptions.dart';
import '../../base/failure.dart';
import '../data/invoice_data_source.dart';
import '../entities/invoice_status.dart';

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
      required List<InvoiceItem> items,
      required bool sendEmail}) async {
    try {
      final models = await invoiceRemoteDataSource.createNewInvoices(
          companyId: companyId,
          receiverIds: receiverIds,
          invoiceName: invoiceName,
          bankAccountId: bankAccountId,
          paymentDate: paymentDate,
          items: items
              .map((e) => InvoiceItemModel(
                  name: e.name,
                  description: e.description,
                  unit_cost: e.unitCost,
                  quantity: e.quantity,
                  total: e.total,
                  tax_percentage: e.taxPercentage))
              .toList(),
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
      {required String invoiceId, required List<String> emails}) async {
    try {
      final model = await invoiceRemoteDataSource.sendInvoiceManually(
          invoiceId: invoiceId, emails: emails);
      return ResultSuccess(Invoice.modelToEntity(model));
    } on ServerException {
      return ResultFailure(ServerFailure());
    }
  }
}

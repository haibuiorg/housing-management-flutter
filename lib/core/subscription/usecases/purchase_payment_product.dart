import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/usecase.dart';

import '../../base/result.dart';
import '../repos/subscription_repository.dart';

class PurchasePaymentProduct
    extends UseCase<String, PurchasePaymentProductParams> {
  final SubscriptionRepository repository;

  PurchasePaymentProduct({required this.repository});

  @override
  Future<Result<String>> call(PurchasePaymentProductParams params) async {
    return repository.purchasePaymentProduct(
        companyId: params.companyId,
        paymentProductItemId: params.paymentProductItemId,
        quantity: params.quantity);
  }
}

class PurchasePaymentProductParams extends Equatable {
  final String companyId;
  final String paymentProductItemId;
  final int quantity;

  const PurchasePaymentProductParams(
      {required this.companyId,
      required this.paymentProductItemId,
      required this.quantity});

  @override
  List<Object?> get props => [companyId, paymentProductItemId, quantity];
}

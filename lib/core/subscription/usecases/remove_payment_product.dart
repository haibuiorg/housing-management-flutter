import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../repos/subscription_repository.dart';

class RemovePaymentProduct extends UseCase<bool, RemovePaymentProductParams> {
  final SubscriptionRepository repository;

  RemovePaymentProduct({required this.repository});
  @override
  Future<Result<bool>> call(RemovePaymentProductParams params) {
    return repository.deletePaymentProductItem(
        paymentProductItemId: params.paymentProductId);
  }
}

class RemovePaymentProductParams extends Equatable {
  final String paymentProductId;
  const RemovePaymentProductParams({required this.paymentProductId});

  @override
  List<Object?> get props => [paymentProductId];
}

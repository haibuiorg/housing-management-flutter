import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';
import 'package:priorli/core/subscription/repos/subscription_repository.dart';

import '../../base/usecase.dart';

class GetPaymentProducts
    extends UseCase<List<PaymentProductItem>, GetPaymentProductParams> {
  final SubscriptionRepository repository;

  GetPaymentProducts({required this.repository});

  @override
  Future<Result<List<PaymentProductItem>>> call(
      GetPaymentProductParams params) async {
    return repository.getPaymentProductItems(countryCode: params.countryCode);
  }
}

class GetPaymentProductParams extends Equatable {
  final String countryCode;

  const GetPaymentProductParams({required this.countryCode});

  @override
  List<Object?> get props => [countryCode];
}

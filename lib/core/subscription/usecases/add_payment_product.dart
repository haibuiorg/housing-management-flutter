import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/subscription/entities/payment_product_item.dart';
import 'package:priorli/core/subscription/repos/subscription_repository.dart';

import '../../base/usecase.dart';

class AddPaymentProduct
    extends UseCase<PaymentProductItem, AddPaymentProductParams> {
  final SubscriptionRepository repository;

  AddPaymentProduct({required this.repository});

  @override
  Future<Result<PaymentProductItem>> call(
      AddPaymentProductParams params) async {
    return await repository.addPaymentProductItem(
        name: params.name,
        description: params.description,
        price: params.price,
        countryCode: params.countryCode);
  }
}

class AddPaymentProductParams extends Equatable {
  final String name;
  final String description;
  final double price;
  final String countryCode;

  const AddPaymentProductParams(
      {required this.name,
      required this.description,
      required this.price,
      required this.countryCode});

  @override
  List<Object?> get props => [name, description, price, countryCode];
}

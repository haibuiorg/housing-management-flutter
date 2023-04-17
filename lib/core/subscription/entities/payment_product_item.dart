import 'package:equatable/equatable.dart';
import 'package:priorli/core/subscription/models/payment_product_item_model.dart';

class PaymentProductItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double amount;
  final String currencyCode;
  final String countryCode;
  final bool isActive;
  final String stripeProductId;
  final String stripePriceId;
  final double taxPercentage;
  final int createdOn;
  final int? updatedon;

  const PaymentProductItem(
      {required this.id,
      required this.name,
      required this.description,
      required this.amount,
      required this.currencyCode,
      required this.countryCode,
      required this.isActive,
      required this.stripeProductId,
      required this.stripePriceId,
      required this.createdOn,
      required this.taxPercentage,
      this.updatedon});

  factory PaymentProductItem.modelToEntity(PaymentProductItemModel model) =>
      PaymentProductItem(
        id: model.id,
        name: model.name,
        description: model.description,
        amount: model.amount,
        currencyCode: model.currency_code,
        countryCode: model.country_code,
        isActive: model.is_active,
        stripeProductId: model.stripe_product_id,
        stripePriceId: model.stripe_price_id,
        createdOn: model.created_on,
        updatedon: model.updated_on,
        taxPercentage: model.tax_percentage,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        amount,
        currencyCode,
        countryCode,
        isActive,
        stripeProductId,
        stripePriceId,
        createdOn,
        updatedon,
        taxPercentage
      ];
}

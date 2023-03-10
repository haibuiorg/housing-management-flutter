import 'package:equatable/equatable.dart';
import 'package:priorli/core/base/result.dart';

import '../../base/usecase.dart';
import '../entities/subscription.dart';
import '../repos/subscription_repository.dart';

class GetSubscriptions
    extends UseCase<List<Subscription>, GetSubscriptionParams> {
  final SubscriptionRepository repository;

  GetSubscriptions({required this.repository});

  @override
  Future<Result<List<Subscription>>> call(GetSubscriptionParams params) {
    return repository.getCompanySubscriptions(companyId: params.companyId);
  }
}

class GetSubscriptionParams extends Equatable {
  final String companyId;
  const GetSubscriptionParams({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

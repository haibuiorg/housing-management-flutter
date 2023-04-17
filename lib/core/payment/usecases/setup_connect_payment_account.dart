import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/housing/usecases/get_housing_company.dart';

import '../../base/usecase.dart';
import '../repos/payment_repository.dart';

class SetupConnectPaymentAccount
    extends UseCase<String, GetHousingCompanyParams> {
  final PaymentRepository paymentRepository;

  SetupConnectPaymentAccount({required this.paymentRepository});

  @override
  Future<Result<String>> call(GetHousingCompanyParams params) async {
    return await paymentRepository.setupConnectPaymentAccount(
        housingCompanyId: params.housingCompanyId);
  }
}

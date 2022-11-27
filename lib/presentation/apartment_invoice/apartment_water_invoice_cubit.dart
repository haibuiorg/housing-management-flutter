import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/base/result.dart';
import 'package:priorli/core/water_usage/entities/water_bill.dart';
import 'package:priorli/core/water_usage/usecases/get_water_bill.dart';
import 'package:priorli/core/water_usage/usecases/get_water_bill_by_year.dart';
import 'package:priorli/core/water_usage/usecases/get_water_bill_link.dart';

import '../../core/apartment/usecases/get_apartment.dart';
import 'apartment_water_invoice_state.dart';

class ApartmentWaterInvoiceCubit extends Cubit<ApartmentWaterInvoiceState> {
  final GetApartment _getApartment;
  final GetWaterBillByYear _getWaterBillByYear;
  final GetWaterBillLink _getWaterBillLink;

  ApartmentWaterInvoiceCubit(
      this._getApartment, this._getWaterBillLink, this._getWaterBillByYear)
      : super(const ApartmentWaterInvoiceState());

  Future<ApartmentWaterInvoiceState> init(
      String housingCompanyId, String apartmentId) async {
    final getApartmentResult = await _getApartment(GetApartmentSingleParams(
        apartmentId: apartmentId, housingCompanyId: housingCompanyId));
    final getWaterBillByYearResult = await _getWaterBillByYear(
        GetWaterBillParams(
            housingCompanyId: housingCompanyId,
            apartmentId: apartmentId,
            year: DateTime.now().year));
    ApartmentWaterInvoiceState pendingState = state.copyWith();
    if (getApartmentResult is ResultSuccess<Apartment>) {
      pendingState = state.copyWith(
        apartment: getApartmentResult.data,
      );
    }
    if (getWaterBillByYearResult is ResultSuccess<List<WaterBill>>) {
      pendingState =
          pendingState.copyWith(waterBillList: getWaterBillByYearResult.data);
    }
    emit(pendingState);
    return state;
  }

  Future<void> getWaterBillLink(int positionInWaterBillList) async {
    final billId = state.waterBillList?[positionInWaterBillList].id ?? '';
    final getWaterBillLinkResult =
        await _getWaterBillLink(GetWaterBillLinkParams(waterBillId: billId));
    if (getWaterBillLinkResult is ResultSuccess<String>) {
      emit(state.copyWith(waterBillLink: getWaterBillLinkResult.data));
    }
  }

  Future<void> dismissWaterbill() async {
    emit(state.copyWith(waterBillLink: ''));
  }
}

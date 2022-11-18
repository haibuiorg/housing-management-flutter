import 'package:equatable/equatable.dart';

import '../../base/result.dart';
import '../../base/usecase.dart';
import '../entities/housing_company.dart';
import '../entities/ui.dart';
import '../repos/housing_company_repository.dart';

class UpdateHousingCompanyInfo
    extends UseCase<HousingCompany, UpdateHousingCompanyInfoParams> {
  final HousingCompanyRepository housingCompanyRepository;

  UpdateHousingCompanyInfo({required this.housingCompanyRepository});

  @override
  Future<Result<HousingCompany>> call(UpdateHousingCompanyInfoParams params) {
    return housingCompanyRepository.updateHousingCompanyInfo(
        name: params.name,
        housingCompanyId: params.housingCompanyId,
        streetAddress1: params.streetAddress1,
        streetAddress2: params.streetAddress2,
        postalCode: params.postalCode,
        city: params.city,
        countryCode: params.countryCode,
        lat: params.lat,
        ui: params.ui,
        lng: params.lng);
  }
}

class UpdateHousingCompanyInfoParams extends Equatable {
  final String? name;
  final String housingCompanyId;
  final String? streetAddress1;
  final String? streetAddress2;
  final String? postalCode;
  final String? city;
  final double? lat;
  final double? lng;
  final String? countryCode;
  final UI? ui;

  const UpdateHousingCompanyInfoParams(
      {this.streetAddress1,
      this.streetAddress2,
      this.postalCode,
      this.city,
      this.lat,
      this.lng,
      this.countryCode,
      this.name,
      this.ui,
      required this.housingCompanyId});
  @override
  List<Object?> get props => [name];
}

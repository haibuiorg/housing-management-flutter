import 'package:equatable/equatable.dart';
import 'package:priorli/core/country/entities/country.dart';

class CreateHousingCompanyState extends Equatable {
  final String? companyName;
  final String? errorText;
  final String? newCompanyId;
  final List<Country>? countryList;
  final String? selectedCountryCode;

  const CreateHousingCompanyState(
      {this.companyName,
      this.errorText,
      this.newCompanyId,
      this.countryList,
      this.selectedCountryCode});

  CreateHousingCompanyState copyWith(
          {String? companyName,
          String? errorText,
          String? newCompanyId,
          String? selectedCountryCode,
          List<Country>? countryList}) =>
      CreateHousingCompanyState(
          countryList: countryList ?? this.countryList,
          selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
          companyName: companyName ?? this.companyName,
          errorText: errorText ?? this.errorText,
          newCompanyId: newCompanyId ?? this.newCompanyId);

  @override
  List<Object?> get props =>
      [companyName, errorText, newCompanyId, countryList, selectedCountryCode];
}

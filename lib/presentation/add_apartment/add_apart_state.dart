import 'package:equatable/equatable.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class AddApartmentState extends Equatable {
  final String? housingCompanyId;
  final HousingCompany? housingCompany;
  final String? building;
  final List<String>? houseCodes;
  final String? errorText;
  final List<Apartment>? addedApartments;
  final bool? automaticHouseCodeInput;
  const AddApartmentState(
      {this.errorText,
      this.addedApartments,
      this.housingCompanyId,
      this.building,
      this.houseCodes,
      this.automaticHouseCodeInput,
      this.housingCompany});

  AddApartmentState copyWith(
          {String? housingCompanyId,
          List<String>? houseCodes,
          String? building,
          String? errorText,
          HousingCompany? housingCompany,
          List<Apartment>? addedApartments,
          bool? automaticHouseCodeInput}) =>
      AddApartmentState(
          housingCompanyId: housingCompanyId ?? this.housingCompanyId,
          building: building ?? this.building,
          houseCodes: houseCodes ?? this.houseCodes,
          errorText: errorText ?? this.errorText,
          housingCompany: housingCompany ?? this.housingCompany,
          automaticHouseCodeInput:
              automaticHouseCodeInput ?? this.automaticHouseCodeInput,
          addedApartments: addedApartments ?? this.addedApartments);

  @override
  List<Object?> get props => [
        housingCompanyId,
        errorText,
        addedApartments,
        housingCompany,
        building,
        houseCodes,
        automaticHouseCodeInput
      ];
}

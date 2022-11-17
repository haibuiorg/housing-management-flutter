import 'package:equatable/equatable.dart';

class CreateHousingCompanyState extends Equatable {
  final String? companyName;
  final String? errorText;
  final String? newCompanyId;

  const CreateHousingCompanyState(
      {this.companyName, this.errorText, this.newCompanyId});

  CreateHousingCompanyState copyWith(
          {String? companyName, String? errorText, String? newCompanyId}) =>
      CreateHousingCompanyState(
          companyName: companyName ?? this.companyName,
          errorText: errorText ?? this.errorText,
          newCompanyId: newCompanyId ?? this.newCompanyId);

  @override
  List<Object?> get props => [companyName, errorText, newCompanyId];
}

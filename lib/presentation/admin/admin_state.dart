import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class AdminState extends Equatable {
  final List<HousingCompany>? companyList;

  const AdminState({this.companyList});

  AdminState copyWith({List<HousingCompany>? companyList}) =>
      AdminState(companyList: companyList ?? this.companyList);

  @override
  List<Object?> get props => [companyList];
}

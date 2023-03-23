import 'package:equatable/equatable.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

import '../../core/apartment/entities/apartment.dart';
import '../../core/user/entities/user.dart';

class CompanyUserState extends Equatable {
  final List<User>? userList;
  final List<User>? managerList;
  final List<Apartment>? apartmentList;
  final HousingCompany? company;
  final int userListLimit;
  final int managerListLimit;

  const CompanyUserState({
    this.userList,
    this.managerList,
    this.apartmentList,
    this.company,
    this.userListLimit = 5,
    this.managerListLimit = 5,
  });

  CompanyUserState copyWith(
          {List<User>? userList,
          List<User>? managerList,
          List<Apartment>? apartmentList,
          HousingCompany? company,
          int? userListLimit,
          int? managerListLimit}) =>
      CompanyUserState(
          apartmentList: apartmentList ?? this.apartmentList,
          managerListLimit: managerListLimit ?? this.managerListLimit,
          userListLimit: userListLimit ?? this.userListLimit,
          company: company ?? this.company,
          managerList: managerList ?? this.managerList,
          userList: userList ?? this.userList);
  @override
  List<Object?> get props => [
        userList,
        managerList,
        company,
        userListLimit,
        managerListLimit,
        apartmentList
      ];
}

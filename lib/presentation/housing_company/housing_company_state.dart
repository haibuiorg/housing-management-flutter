import 'package:equatable/equatable.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/user/entities/user.dart';

import '../../core/water_usage/entities/water_consumption.dart';

class HousingCompanyState extends Equatable {
  final HousingCompany? housingCompany;
  final List<Apartment>? apartmentList;
  final List<Announcement>? announcementList;
  final List<WaterConsumption>? yearlyWaterConsumption;
  final List<Conversation>? conversationList;
  final User? user;
  const HousingCompanyState(
      {this.housingCompany,
      this.announcementList,
      this.apartmentList,
      this.conversationList,
      this.yearlyWaterConsumption,
      this.user});

  HousingCompanyState copyWith(
          {HousingCompany? housingCompany,
          List<Apartment>? apartmentList,
          List<Announcement>? announcementList,
          List<Conversation>? conversationList,
          User? user,
          List<WaterConsumption>? yearlyWaterConsumption}) =>
      HousingCompanyState(
          user: user ?? this.user,
          announcementList: announcementList ?? this.announcementList,
          conversationList: conversationList ?? this.conversationList,
          yearlyWaterConsumption:
              yearlyWaterConsumption ?? this.yearlyWaterConsumption,
          housingCompany: housingCompany ?? this.housingCompany,
          apartmentList: apartmentList ?? this.apartmentList);

  @override
  List<Object?> get props => [
        housingCompany,
        apartmentList,
        yearlyWaterConsumption,
        announcementList,
        conversationList,
        user
      ];
}

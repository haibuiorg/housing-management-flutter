import 'package:equatable/equatable.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';
import 'package:priorli/core/invoice/entities/invoice_group.dart';
import 'package:priorli/core/messaging/entities/conversation.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';
import 'package:priorli/core/user/entities/user.dart';

import '../../core/event/entities/event.dart';
import '../../core/poll/entities/poll.dart';
import '../../core/water_usage/entities/water_consumption.dart';

class HousingCompanyState extends Equatable {
  final HousingCompany? housingCompany;
  final List<Apartment>? apartmentList;
  final List<Announcement>? announcementList;
  final List<WaterConsumption>? yearlyWaterConsumption;
  final List<Conversation>? conversationList;
  final List<Conversation>? faultReportList;
  final List<StorageItem>? documentList;
  final List<Event>? ongoingEventList;
  final List<Poll>? ongoingPollList;
  final List<InvoiceGroup>? invoiceGroupList;

  final User? user;
  const HousingCompanyState(
      {this.housingCompany,
      this.announcementList,
      this.apartmentList,
      this.conversationList,
      this.yearlyWaterConsumption,
      this.ongoingEventList,
      this.ongoingPollList,
      this.faultReportList,
      this.invoiceGroupList,
      this.documentList,
      this.user});

  HousingCompanyState copyWith({
    HousingCompany? housingCompany,
    List<Apartment>? apartmentList,
    List<Announcement>? announcementList,
    List<Conversation>? conversationList,
    List<Conversation>? faultReportList,
    List<InvoiceGroup>? invoiceGroupList,
    User? user,
    List<Event>? ongoingEventList,
    List<StorageItem>? documentList,
    List<WaterConsumption>? yearlyWaterConsumption,
    List<Poll>? ongoingPollList,
  }) {
    return HousingCompanyState(
      user: user ?? this.user,
      invoiceGroupList: invoiceGroupList ?? this.invoiceGroupList,
      faultReportList: faultReportList ?? this.faultReportList,
      ongoingEventList: ongoingEventList ?? this.ongoingEventList,
      documentList: documentList ?? this.documentList,
      announcementList: announcementList ?? this.announcementList,
      conversationList: conversationList ?? this.conversationList,
      yearlyWaterConsumption:
          yearlyWaterConsumption ?? this.yearlyWaterConsumption,
      housingCompany: housingCompany ?? this.housingCompany,
      apartmentList: apartmentList ?? this.apartmentList,
      ongoingPollList: ongoingPollList ?? this.ongoingPollList,
    );
  }

  @override
  List<Object?> get props => [
        ongoingPollList,
        housingCompany,
        apartmentList,
        yearlyWaterConsumption,
        announcementList,
        conversationList,
        documentList,
        ongoingEventList,
        faultReportList,
        invoiceGroupList,
        user
      ];
}

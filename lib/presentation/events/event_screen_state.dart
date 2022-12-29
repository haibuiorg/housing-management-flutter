import 'package:equatable/equatable.dart';
import 'package:priorli/core/event/entities/event.dart';
import 'package:priorli/core/housing/entities/housing_company.dart';

class EventScreenState extends Equatable {
  final String? companyId;
  final String? apartmentId;
  final Event? event;
  final String? userId;
  final HousingCompany? company;
  final bool isInitializing;

  const EventScreenState(
      {this.event,
      this.userId,
      this.apartmentId,
      this.companyId,
      this.company,
      this.isInitializing = true});

  EventScreenState copyWith(
          {Event? event,
          String? apartmentId,
          String? companyId,
          String? userId,
          HousingCompany? company,
          bool? isInitializing}) =>
      EventScreenState(
          companyId: companyId ?? this.companyId,
          apartmentId: apartmentId ?? this.apartmentId,
          event: event ?? this.event,
          userId: userId ?? this.userId,
          company: company ?? this.company,
          isInitializing: isInitializing ?? this.isInitializing);

  @override
  List<Object?> get props =>
      [event, apartmentId, companyId, isInitializing, userId, company];
}

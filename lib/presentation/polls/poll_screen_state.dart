import 'package:equatable/equatable.dart';
import 'package:priorli/core/poll/entities/poll.dart';

import '../../core/housing/entities/housing_company.dart';

class PollScreenState extends Equatable {
  final String? companyId;
  final Poll? poll;
  final String? userId;
  final HousingCompany? company;
  final bool isInitializing;

  const PollScreenState({
    this.companyId,
    this.poll,
    this.userId,
    this.company,
    this.isInitializing = true,
  });

  PollScreenState copyWith(
          {Poll? poll,
          String? userId,
          HousingCompany? company,
          bool? isInitializing,
          String? companyId}) =>
      PollScreenState(
          isInitializing: isInitializing ?? this.isInitializing,
          userId: userId ?? this.userId,
          company: company ?? this.company,
          poll: poll ?? this.poll,
          companyId: companyId ?? this.companyId);

  @override
  List<Object?> get props => [companyId, userId, company, isInitializing, poll];
}

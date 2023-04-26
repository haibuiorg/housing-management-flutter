import 'package:equatable/equatable.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';

class AnnouncementState extends Equatable {
  final String? housingCompanyId;
  final bool? isManager;
  final List<Announcement>? announcementList;
  final int? total;
  final bool? isLoading;
  final String? error;

  const AnnouncementState(
      {this.announcementList,
      this.total,
      this.housingCompanyId,
      this.isLoading,
      this.error,
      this.isManager});

  AnnouncementState copyWith(
          {List<Announcement>? announcementList,
          int? total,
          bool? isManager,
          bool? isLoading,
          String? error,
          String? housingCompanyId}) =>
      AnnouncementState(
          isLoading: isLoading ?? this.isLoading,
          isManager: isManager ?? this.isManager,
          housingCompanyId: housingCompanyId ?? this.housingCompanyId,
          announcementList: announcementList ?? this.announcementList,
          error: error ?? this.error,
          total: total ?? total);

  @override
  List<Object?> get props =>
      [announcementList, total, housingCompanyId, isManager, error, isLoading];
}

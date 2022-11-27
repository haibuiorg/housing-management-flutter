import 'package:equatable/equatable.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';

class AnnouncementState extends Equatable {
  final String? housingCompanyId;
  final List<Announcement>? announcementList;
  final int? total;

  const AnnouncementState(
      {this.announcementList, this.total, this.housingCompanyId});

  AnnouncementState copyWith(
          {List<Announcement>? announcementList,
          int? total,
          String? housingCompanyId}) =>
      AnnouncementState(
          housingCompanyId: housingCompanyId ?? this.housingCompanyId,
          announcementList: announcementList ?? this.announcementList,
          total: total ?? total);

  @override
  List<Object?> get props => [announcementList, total, housingCompanyId];
}

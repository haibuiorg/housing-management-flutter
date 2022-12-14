import 'package:equatable/equatable.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';

class AnnouncementItemState extends Equatable {
  final String? housingCompanyId;
  final Announcement? announcement;

  const AnnouncementItemState({this.announcement, this.housingCompanyId});

  AnnouncementItemState copyWith(
          {Announcement? announcement, String? housingCompanyId}) =>
      AnnouncementItemState(
        housingCompanyId: housingCompanyId ?? this.housingCompanyId,
        announcement: announcement ?? this.announcement,
      );

  @override
  List<Object?> get props => [announcement, housingCompanyId];
}

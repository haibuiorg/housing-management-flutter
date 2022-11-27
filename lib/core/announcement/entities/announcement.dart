import 'package:equatable/equatable.dart';
import 'package:priorli/core/announcement/models/announcement_model.dart';

class Announcement extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String body;
  final int createdOn;
  final String createdBy;
  final String? updatedBy;
  final int? updatedOn;
  final String displayName;
  final bool isDeleted;

  const Announcement(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.body,
      required this.createdOn,
      required this.createdBy,
      this.updatedBy,
      this.updatedOn,
      required this.displayName,
      required this.isDeleted});

  factory Announcement.modelToEntity(AnnouncementModel model) => Announcement(
      id: model.id ?? '',
      title: model.title ?? '',
      subtitle: model.subtitle ?? '',
      body: model.body ?? '',
      createdOn: model.created_on ?? 0,
      createdBy: model.created_by ?? '',
      updatedBy: model.updated_by,
      updatedOn: model.updated_on,
      displayName: model.display_name ?? '',
      isDeleted: model.is_deleted ?? model.id != null);

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        body,
        createdBy,
        createdOn,
        updatedBy,
        updatedOn,
        displayName,
        isDeleted
      ];
}

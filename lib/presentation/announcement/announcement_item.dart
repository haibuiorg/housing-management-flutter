
import 'package:flutter/material.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';

import '../../core/utils/time_utils.dart';

class AnnouncementItem extends StatefulWidget {
  const AnnouncementItem(
      {super.key, required this.announcement, this.initialExpand = false});
  final Announcement announcement;
  final bool initialExpand;

  @override
  State<AnnouncementItem> createState() => _AnnouncementItemState();
}

class _AnnouncementItemState extends State<AnnouncementItem> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initialExpand;
  }

  _expand() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.color,
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _expand,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.announcement.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                widget.announcement.subtitle,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              _expanded
                  ? Text(
                      widget.announcement.body,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : const SizedBox.shrink(),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                    '${widget.announcement.updatedOn != null ? 'Edited on' : 'Created on'} ${getFormattedDateTime(widget.announcement.updatedOn ?? widget.announcement.createdOn)} by ${widget.announcement.displayName}'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/presentation/announcement/announcement_item_cubit.dart';
import 'package:priorli/presentation/announcement/announcement_item_state.dart';
import 'package:priorli/presentation/shared/app_image_row.dart';
import 'package:priorli/presentation/shared/tap_card.dart';
import 'package:priorli/service_locator.dart';

import '../../core/utils/time_utils.dart';

class AnnouncementItem extends StatefulWidget {
  const AnnouncementItem(
      {super.key,
      required this.announcement,
      required this.companyId,
      this.initialExpand = false});
  final Announcement announcement;
  final bool initialExpand;
  final String companyId;

  @override
  State<AnnouncementItem> createState() => _AnnouncementItemState();
}

class _AnnouncementItemState extends State<AnnouncementItem> {
  late bool _expanded;
  late AnnouncementItemCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<AnnouncementItemCubit>();
    _cubit.init(widget.companyId, widget.announcement);
    _expanded = widget.initialExpand;
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  _expand() {
    setState(() {
      _expanded = !_expanded;
    });
    _cubit.getAnnouncementDetail();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnnouncementItemCubit>(
      create: (context) => _cubit,
      child: BlocBuilder<AnnouncementItemCubit, AnnouncementItemState>(
          builder: (context, state) {
        return TapCard(
          onTap: _expand,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.announcement?.title ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  state.announcement?.subtitle ?? '',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                _expanded
                    ? AppImageRow(
                        storageItems: state.announcement?.storageItems)
                    : const SizedBox.shrink(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      '${state.announcement?.updatedOn != null ? 'Edited on' : 'Created on'} ${getFormattedDateTime(state.announcement?.updatedOn ?? state.announcement?.createdOn ?? 0)} by ${state.announcement?.displayName}'),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

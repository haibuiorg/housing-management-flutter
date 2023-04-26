import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/announcement/entities/announcement.dart';
import 'package:priorli/presentation/announcement/announcement_item_cubit.dart';
import 'package:priorli/presentation/announcement/announcement_item_state.dart';
import 'package:priorli/presentation/shared/app_image_row.dart';
import 'package:priorli/service_locator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/utils/time_utils.dart';

class AnnouncementItem extends StatefulWidget {
  const AnnouncementItem({
    super.key,
    required this.announcement,
    required this.companyId,
  });
  final Announcement announcement;
  final String companyId;

  @override
  State<AnnouncementItem> createState() => _AnnouncementItemState();
}

class _AnnouncementItemState extends State<AnnouncementItem> {
  late AnnouncementItemCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<AnnouncementItemCubit>();
    _cubit.init(widget.companyId, widget.announcement);
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  _expand() {
    _cubit.getAnnouncementDetail().then((announcement) => {
          if (announcement != null)
            {
              showDialog(
                  context: context,
                  builder: (builder) {
                    return Dialog.fullscreen(
                      child: Scaffold(
                          appBar: AppBar(
                            title: Text(announcement.title),
                          ),
                          body: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(announcement.subtitle),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                    '${announcement.updatedOn != null ? 'Edited on' : 'Created on'} ${getFormattedDateTime(announcement.updatedOn ?? announcement.createdOn)} by ${announcement.displayName}'),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: AppImageRow(
                                    storageItems: announcement.storageItems,
                                  ),
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        announcement.body,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          )),
                    );
                  })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnnouncementItemCubit>(
      create: (context) => _cubit,
      child: BlocBuilder<AnnouncementItemCubit, AnnouncementItemState>(
          builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: ListTile(
            tileColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
            isThreeLine: false,
            trailing: (state.announcement?.storageItems?.isNotEmpty == true)
                ? const IconButton(
                    onPressed: null, icon: Icon(Icons.attachment_rounded))
                : null,
            title: Text(widget.announcement.translatedTitle
                    ?.where((element) =>
                        element.languageCode ==
                        AppLocalizations.of(context)!.localeName)
                    .firstOrNull
                    ?.value ??
                widget.announcement.title),
            subtitle: Text(
              '${widget.announcement.translatedSubtitle?.where((element) => element.languageCode == AppLocalizations.of(context)!.localeName).firstOrNull?.value ?? widget.announcement.subtitle}\n${state.announcement?.updatedOn != null ? 'Edited on' : 'Created on'} ${getFormattedDateTime(state.announcement?.updatedOn ?? state.announcement?.createdOn ?? 0)} by ${state.announcement?.displayName}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              _expand();
            },
          ),
        );
      }),
    );
  }
}

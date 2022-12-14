import 'package:flutter/material.dart';
import 'package:priorli/core/notification/entities/notification_message.dart';
import 'package:priorli/presentation/shared/tap_card.dart';

import '../../../core/utils/time_utils.dart';

class NotificationCenterItem extends StatelessWidget {
  const NotificationCenterItem(
      {super.key, required this.notificationMessage, required this.onPress});
  final NotificationMessage notificationMessage;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TapCard(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notificationMessage.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(notificationMessage.body),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Text(
                    'Sent on ${getFormattedDateTime(notificationMessage.createdOn)} by ${notificationMessage.displayName}',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.end,
                  ),
                ),
                !notificationMessage.seen
                    ? const CircleAvatar(
                        radius: 4,
                      )
                    : const SizedBox.shrink()
              ])
            ],
          ),
        ),
      ),
    );
  }
}

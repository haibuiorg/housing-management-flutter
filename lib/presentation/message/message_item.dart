import 'package:flutter/material.dart';
import 'package:priorli/core/messaging/entities/message.dart';

import '../../core/utils/time_utils.dart';

class MessageItem extends StatefulWidget {
  const MessageItem(
      {super.key, required this.message, required this.isMyMessage});
  final Message message;
  final bool isMyMessage;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Wrap(
        children: [
          Align(
            alignment: widget.isMyMessage
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsetsDirectional.symmetric(
                  horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.srcOver,
                  color: widget.isMyMessage
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : Theme.of(context).colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: widget.isMyMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(widget.message.message),
                      Text(
                        getFormattedDateTime(widget.message.createdOn),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      _expanded
                          ? Text(
                              widget.message.senderName,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

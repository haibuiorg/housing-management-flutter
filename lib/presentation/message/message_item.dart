import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:priorli/core/messaging/entities/message.dart';
import 'package:priorli/core/messaging/entities/translation.dart';
import 'package:priorli/presentation/shared/app_gallery.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';

import '../../core/utils/time_utils.dart';

class MessageItem extends StatefulWidget {
  const MessageItem(
      {super.key,
      required this.message,
      required this.isMyMessage,
      this.translatedLanguageCode});
  final Message message;
  final bool isMyMessage;
  final String? translatedLanguageCode;

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
            child: widget.message.id == "-1"
                ? const SizedBox(
                    width: 100,
                    child: AppLottieAnimation(
                      loadingResource: 'apartment',
                    ),
                  )
                : SelectionArea(
                    child: Container(
                      margin: const EdgeInsetsDirectional.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: widget.isMyMessage
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
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
                              Text(widget.message.translatedMessage?.firstWhere(
                                    (element) =>
                                        element.languageCode ==
                                        widget.translatedLanguageCode,
                                    orElse: () {
                                      return Translation(
                                          value: widget.message.message,
                                          languageCode: '');
                                    },
                                  ).value ??
                                  widget.message.message),
                              Text(
                                getFormattedDateTime(widget.message.createdOn),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              widget.message.storageItems?.isNotEmpty == true
                                  ? SizedBox(
                                      height: 100,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        reverse: widget.isMyMessage,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: widget
                                                .message.storageItems?.length ??
                                            0,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: CachedNetworkImage(
                                                errorWidget:
                                                    (context, url, error) {
                                                  return SizedBox(
                                                    width: 100,
                                                    height: 100,
                                                    child: InkWell(
                                                      onTap: () {
                                                        showBottomSheet(
                                                            context: context,
                                                            builder: (builder) => AppGallery(
                                                                galleryItems: widget
                                                                        .message
                                                                        .storageItems ??
                                                                    []));
                                                      },
                                                      child:
                                                          const AppLottieAnimation(
                                                        loadingResource:
                                                            'documents',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return InkWell(
                                                    onTap: () {
                                                      showBottomSheet(
                                                          context: context,
                                                          builder: (builder) =>
                                                              AppGallery(
                                                                  galleryItems: widget
                                                                          .message
                                                                          .storageItems ??
                                                                      []));
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                imageProvider),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                imageUrl: widget
                                                        .message
                                                        .storageItems?[index]
                                                        .presignedUrl ??
                                                    ''),
                                          );
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              _expanded
                                  ? Text(
                                      widget.message.senderName,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
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

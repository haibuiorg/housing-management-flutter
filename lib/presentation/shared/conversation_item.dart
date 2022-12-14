import 'package:flutter/material.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/shared/tap_card.dart';

import '../../core/messaging/entities/conversation.dart';

import 'setting_button.dart';

class ConversationItem extends StatelessWidget {
  const ConversationItem(
      {super.key, required this.conversation, this.onPressed});
  final Conversation conversation;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return TapCard(
      onTap: onPressed,
      child: SettingButton(
        label: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Text(
                conversation.name.characters.isNotEmpty
                    ? conversation.name.characters.first.toUpperCase()
                    : '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                conversation.name.capitalize(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
        icon: !conversation.seen
            ? const CircleAvatar(
                radius: 4,
              )
            : const SizedBox.shrink(),
        showUnderline: false,
      ),
    );
  }
}

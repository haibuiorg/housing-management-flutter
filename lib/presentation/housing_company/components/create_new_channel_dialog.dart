import 'package:flutter/material.dart';

import '../../shared/custom_form_field.dart';

class CreateNewChannelDialog extends StatefulWidget {
  const CreateNewChannelDialog({super.key, required this.onConfirmed});
  final Function(String channelName) onConfirmed;

  @override
  State<CreateNewChannelDialog> createState() => _CreateNewChannelDialogState();
}

class _CreateNewChannelDialogState extends State<CreateNewChannelDialog> {
  late final TextEditingController _channelName;

  @override
  void initState() {
    _channelName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _channelName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create new channel'),
      content: CustomFormField(
        textEditingController: _channelName,
        hintText: 'Channel name',
      ),
      actions: [
        OutlinedButton(
            onPressed: () {
              widget.onConfirmed(_channelName.text);
            },
            child: const Text('Confirm'))
      ],
    );
  }
}

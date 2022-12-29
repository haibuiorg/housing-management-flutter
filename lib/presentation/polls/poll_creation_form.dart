import 'package:flutter/material.dart';
import 'package:priorli/core/poll/entities/poll_type.dart';

import '../../core/user/entities/user.dart';
import '../../core/utils/time_utils.dart';
import '../housing_company_users/guest_invitation.dart';
import '../shared/custom_form_field.dart';
import '../shared/date_time_selector.dart';
import '../shared/setting_button.dart';

class PollCreationForm extends StatefulWidget {
  const PollCreationForm(
      {super.key,
      required this.companyId,
      this.availablePollTypes,
      required this.onSubmit});

  final String companyId;
  final List<PollType>? availablePollTypes;
  final Function({
    required String name,
    required String description,
    int? endedOn,
    required bool expandable,
    required PollType type,
    required List<String> invitees,
    required bool annonymous,
    required bool multiple,
    required List<String> votingOptions,
  }) onSubmit;

  @override
  State<PollCreationForm> createState() => _PollCreationFormState();
}

class _PollCreationFormState extends State<PollCreationForm> {
  late DateTime _endedOn;
  late PollType _type;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late List<String> _invitees;
  late List<String> _displayName;
  late bool _expandable;
  late bool _annonymous;
  late bool _multiple;
  late List<TextEditingController> _votingOptionControllers;
  late bool _validated;
  @override
  void initState() {
    super.initState();
    _endedOn = DateTime.now().add(const Duration(days: 7));
    _type = PollType.company;
    _descriptionController = TextEditingController();
    _nameController = TextEditingController();
    _invitees = [];
    _displayName = [];
    _votingOptionControllers = [TextEditingController(text: '1')];
    _multiple = false;
    _expandable = true;
    _annonymous = true;
    _validated = false;
  }

  _addVotingOption() {
    setState(() {
      _votingOptionControllers.add((TextEditingController()));
    });
  }

  _removeVotingOption(int index) {
    if (_votingOptionControllers.length < 2) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: const Text('Must have at least 1 voting option'),
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Ok'))
                ],
              ));
      return;
    }
    setState(() {
      _votingOptionControllers[index].dispose();
      _votingOptionControllers.removeAt((index));
    });
  }

  _checkValidation() {
    setState(() {
      _validated = !(_nameController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _votingOptionControllers.isEmpty);
    });
  }

  _submitInfo() {
    widget.onSubmit(
        annonymous: _annonymous,
        description: _descriptionController.text,
        name: _nameController.text,
        endedOn: _endedOn.millisecondsSinceEpoch,
        expandable: _expandable,
        multiple: _multiple,
        type: _type,
        invitees: _invitees,
        votingOptions: _votingOptionControllers.map((e) => e.text).toList());
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    for (var element in _votingOptionControllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !_validated
          ? null
          : FloatingActionButton(
              onPressed: _submitInfo,
              child: const Icon(Icons.check_rounded),
            ),
      appBar: AppBar(
        title: const Text('Create new poll'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomFormField(
              hintText: 'Poll name',
              onChanged: (_) {
                _checkValidation();
              },
              textEditingController: _nameController,
            ),
            CustomFormField(
              hintText: 'Poll description',
              onChanged: (_) {
                _checkValidation();
              },
              textEditingController: _descriptionController,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: List.generate(_votingOptionControllers.length, (index) {
                return CustomFormField(
                  hintText: 'Option: ${index + 1}',
                  helperText: 'Option for participant',
                  textEditingController: _votingOptionControllers[index],
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _removeVotingOption(index);
                          })),
                );
              }),
            ),
            TextButton(
                onPressed: _addVotingOption,
                child: const Text('Add another voting option')),
            SettingButton(
              label: Text(
                  'Poll end by ${getFormattedDateTime(_endedOn.millisecondsSinceEpoch)}'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) => DateTimePicker(
                    onConfirmTime: (dateTime) {
                      setState(() {
                        _endedOn = dateTime;
                      });
                    },
                  ),
                );
              },
            ),
            SettingButton(
              label: Text(
                  'Guests: ${_displayName.isEmpty ? 'None' : _displayName}'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) => GuestInvitation(
                    companyId: widget.companyId,
                    initialSelectedUser: _invitees,
                    onUserSelected: ({required List<User> userList}) {
                      setState(() {
                        _invitees = userList.map((e) => e.userId).toList();
                        _displayName = userList
                            .map((e) => '${e.firstName} ${e.lastName}')
                            .toList();
                      });
                      Navigator.pop(context, true);
                    },
                  ),
                );
              },
            ),
            CheckboxListTile(
                title: const Text('Annonymous poll'),
                value: _annonymous,
                onChanged: (value) {
                  setState(() {
                    _annonymous = !_annonymous;
                  });
                }),
            CheckboxListTile(
                title: const Text('Participant can add voting options to poll'),
                value: _expandable,
                onChanged: (value) {
                  setState(() {
                    _expandable = !_expandable;
                  });
                }),
            CheckboxListTile(
                title: const Text(
                    'Participant can select multiple voting options'),
                value: _multiple,
                onChanged: (value) {
                  setState(() {
                    _multiple = !_multiple;
                  });
                }),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: List.generate(
                  widget.availablePollTypes?.length ?? PollType.values.length,
                  (index) {
                return ChoiceChip(
                  labelPadding: const EdgeInsets.all(2.0),
                  label: Text(PollType.values[index].name),
                  selected: _type == PollType.values[index],
                  onSelected: (value) {
                    setState(() {
                      _type = PollType.values[index];
                    });
                  },
                  elevation: 1,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

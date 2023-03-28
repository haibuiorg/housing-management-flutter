import 'package:flutter/material.dart';
import 'package:priorli/core/poll/entities/poll_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/user/entities/user.dart';
import '../../core/utils/time_utils.dart';
import '../guest_invitation/guest_invitation.dart';
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
          builder: (builder) => AlertDialog(
                content: Text(AppLocalizations.of(context).vote_option_error),
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(builder);
                      },
                      child: Text(AppLocalizations.of(context).ok))
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
        title: Text(AppLocalizations.of(context).create_new_poll),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomFormField(
              hintText: AppLocalizations.of(context).poll_name,
              onChanged: (_) {
                _checkValidation();
              },
              textEditingController: _nameController,
            ),
            CustomFormField(
              hintText: AppLocalizations.of(context).poll_description,
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
                  hintText: AppLocalizations.of(context)
                      .vote_option_value((index + 1).toString()),
                  helperText: AppLocalizations.of(context).vote_option_title,
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
                child: Text(AppLocalizations.of(context).add_vote_option)),
            SettingButton(
              label: Text(AppLocalizations.of(context).vote_ends_by(
                  getFormattedDateTime(_endedOn.microsecondsSinceEpoch))),
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
                AppLocalizations.of(context).participants_name(
                    _displayName.isEmpty ? '--' : _displayName.join(', ')),
              ),
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
                      Navigator.pop(builder, true);
                    },
                  ),
                );
              },
            ),
            CheckboxListTile(
                title: Text(AppLocalizations.of(context).anonymous_poll),
                value: _annonymous,
                onChanged: (value) {
                  setState(() {
                    _annonymous = !_annonymous;
                  });
                }),
            CheckboxListTile(
                title:
                    Text(AppLocalizations.of(context).participant_add_option),
                value: _expandable,
                onChanged: (value) {
                  setState(() {
                    _expandable = !_expandable;
                  });
                }),
            CheckboxListTile(
                title: Text(
                    AppLocalizations.of(context).participants_select_multiple),
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

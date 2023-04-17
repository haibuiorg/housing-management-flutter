import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/poll/entities/poll_type.dart';
import 'package:priorli/presentation/housing_company/components/poll_chart.dart';
import 'package:priorli/presentation/polls/poll_screen_cubit.dart';
import 'package:priorli/presentation/polls/poll_screen_state.dart';
import 'package:priorli/presentation/shared/full_width_title.dart';

import '../../core/poll/entities/poll.dart';
import '../../core/user/entities/user.dart';
import '../../core/utils/time_utils.dart';
import '../guest_invitation/guest_invitation.dart';
import '../shared/custom_form_field.dart';
import '../shared/date_time_selector.dart';
import '../shared/full_width_pair_text.dart';
import '../shared/setting_button.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PollDetail extends StatefulWidget {
  const PollDetail(
      {super.key,
      required this.poll,
      required this.companyId,
      required this.onDelete,
      this.availablePollTypes,
      required this.onSubmit,
      required this.onAddMoreVotingOptions,
      required this.onRemoveVotingOption,
      required this.onSelectVotingOption,
      required this.userId});
  final Poll poll;
  final String companyId;
  final String userId;
  final Function({
    required String pollId,
  }) onDelete;

  final List<PollType>? availablePollTypes;
  final Function(
      {required String name,
      required String pollId,
      required String description,
      required int endedOn,
      required bool expandable,
      required bool multiple}) onSubmit;
  final Function({
    required String pollId,
    required List<String> votingOptions,
  }) onAddMoreVotingOptions;
  final Function({
    required String pollId,
    required String votingOptionId,
  }) onRemoveVotingOption;
  final Function({
    required String pollId,
    required String votingOptionId,
  }) onSelectVotingOption;

  @override
  State<PollDetail> createState() => _PollDetailState();
}

class _PollDetailState extends State<PollDetail> {
  bool _editable = false;
  late DateTime _endedOn;
  late PollType _type;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late bool _expandable;
  late bool _annonymous;
  late bool _multiple;

  @override
  void initState() {
    _init();
    super.initState();
  }

  _startEdit() {
    setState(() {
      _editable = !_editable;
    });
  }

  _saveEdit() {
    setState(() {
      _editable = !_editable;
    });
    widget.onSubmit(
        description: _descriptionController.text,
        name: _nameController.text,
        endedOn: _endedOn.millisecondsSinceEpoch,
        expandable: _expandable,
        multiple: _multiple,
        pollId: widget.poll.id);
  }

  _clearEdit() {
    setState(() {
      _editable = !_editable;
      _init();
    });
  }

  _addVotingOption() {
    showDialog(
        context: context,
        builder: (builder) => AddPollOptionAlerDialog(onSubmit: (description) {
              widget.onAddMoreVotingOptions(
                  pollId: widget.poll.id, votingOptions: [description]);
              Navigator.pop(builder, true);
            }));
  }

  _showRemovePoll() {
    showDialog(
        context: context,
        builder: (builder) => AlertDialog(
              content: Text(AppLocalizations.of(context).remove_poll_confirm),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(builder, true);
                    },
                    child: Text(AppLocalizations.of(context).cancel)),
                OutlinedButton(
                    onPressed: () {
                      widget.onDelete(pollId: widget.poll.id);
                      Navigator.pop(builder, true);
                      Navigator.pop(context, true);
                    },
                    child: Text(AppLocalizations.of(context).ok))
              ],
            ));
  }

  _removeVotingOption(
    String id,
  ) {
    showDialog(
        context: context,
        builder: (builder) => AlertDialog(
              content: Text(AppLocalizations.of(context).remove_option),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(builder);
                    },
                    child: Text(AppLocalizations.of(context).cancel)),
                OutlinedButton(
                    onPressed: () {
                      widget.onRemoveVotingOption(
                          pollId: widget.poll.id, votingOptionId: id);
                      Navigator.pop(builder, true);
                    },
                    child: Text(AppLocalizations.of(context).ok))
              ],
            ));
  }

  _init() {
    _endedOn = DateTime.fromMillisecondsSinceEpoch(widget.poll.endedOn);
    _type = widget.poll.type;
    _descriptionController =
        TextEditingController(text: widget.poll.description);
    _nameController = TextEditingController(text: widget.poll.name);
    _multiple = widget.poll.multiple;
    _expandable = widget.poll.expandable;
    _annonymous = widget.poll.annonymous;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poll.name),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          FullWidthTitle(
            title: AppLocalizations.of(context).voting_poll_detail,
            action: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: _editable ? _saveEdit : _startEdit,
                      child: Text(_editable
                          ? AppLocalizations.of(context).save
                          : AppLocalizations.of(context).edit)),
                  _editable
                      ? TextButton(
                          onPressed: _clearEdit,
                          child: Text(AppLocalizations.of(context).clear))
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
          CustomFormField(
            textEditingController: _nameController,
            hintText: AppLocalizations.of(context).event_name,
            helperText: AppLocalizations.of(context).event_name,
            enabled: _editable,
            autofocus: false,
          ),
          CustomFormField(
            textEditingController: _descriptionController,
            hintText: AppLocalizations.of(context).event_description,
            helperText: AppLocalizations.of(context).event_description,
            enabled: _editable,
            autofocus: false,
          ),
          _editable
              ? SettingButton(
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
                  label: Text(AppLocalizations.of(context).ended_by_time(
                      getFormattedDateTime(_endedOn.millisecondsSinceEpoch))),
                )
              : FullWidthPairText(
                  label: AppLocalizations.of(context).ended_by_title,
                  content:
                      getFormattedDateTime(_endedOn.millisecondsSinceEpoch)),
          CheckboxListTile(
              enabled: false,
              title: Text(AppLocalizations.of(context).anonymous_poll),
              value: _annonymous,
              onChanged: (value) {
                setState(() {
                  _annonymous = !_annonymous;
                });
              }),
          CheckboxListTile(
              enabled: _editable,
              title: Text(AppLocalizations.of(context).participant_add_option),
              value: _expandable,
              onChanged: (value) {
                setState(() {
                  _expandable = !_expandable;
                });
              }),
          CheckboxListTile(
              enabled: _editable,
              title: Text(
                  AppLocalizations.of(context).participants_select_multiple),
              value: _multiple,
              onChanged: (value) {
                setState(() {
                  _multiple = !_multiple;
                });
              }),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            children: List.generate(
                widget.availablePollTypes?.length ?? PollType.values.length,
                (index) {
              return ChoiceChip(
                labelPadding: const EdgeInsets.all(2.0),
                label: Text(PollType.values[index].name),
                selected: _type == PollType.values[index],
                onSelected: null,
                elevation: 1,
              );
            }),
          ),
          const Divider(),
          FullWidthTitle(
            title: AppLocalizations.of(context).vote_option_title,
          ),
          BlocBuilder<PollScreenCubit, PollScreenState>(
              builder: (context, state) {
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children:
                  List.generate(state.poll?.votingOptions.length ?? 0, (index) {
                return Row(children: [
                  Expanded(
                      child: Text(
                    state.poll?.votingOptions[index].description ?? '',
                  )),
                  TextButton(
                      onPressed: () {
                        _removeVotingOption(
                            state.poll?.votingOptions[index].id.toString() ??
                                '');
                      },
                      child: Text(
                        AppLocalizations.of(context).remove_option,
                      ))
                ]);
              }),
            );
          }),
          TextButton(
              onPressed: _addVotingOption,
              child: Text(
                AppLocalizations.of(context).add_vote_option,
              )),
          const Divider(),
          FullWidthTitle(
            title: AppLocalizations.of(context).your_vote_title,
          ),
          BlocBuilder<PollScreenCubit, PollScreenState>(
              builder: (context, state) {
            return Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              children:
                  List.generate(state.poll?.votingOptions.length ?? 0, (index) {
                return ChoiceChip(
                  labelPadding: const EdgeInsets.all(2.0),
                  label:
                      Text(state.poll?.votingOptions[index].description ?? ''),
                  selected: state.poll?.votingOptions[index].voters
                          .contains(state.userId) ==
                      true,
                  onSelected: (value) {
                    widget.onSelectVotingOption(
                        pollId: state.poll?.id ?? '',
                        votingOptionId:
                            state.poll?.votingOptions[index].id.toString() ??
                                '');
                  },
                  elevation: 1,
                );
              }),
            );
          }),
          BlocBuilder<PollScreenCubit, PollScreenState>(
              builder: (context, state) {
            return state.poll != null
                ? PollChart(poll: state.poll!)
                : const SizedBox.shrink();
          }),
          const Divider(),
          SettingButton(
            label: Text(AppLocalizations.of(context).manage_participants),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (builder) => GuestInvitation(
                  pollId: widget.poll.id,
                  companyId: widget.companyId,
                  onUserSelected: ({required List<User> userList}) {
                    Navigator.pop(builder, true);
                  },
                ),
              );
            },
          ),
          TextButton(
              onPressed: _showRemovePoll,
              child: Text(AppLocalizations.of(context).remove_poll)),
        ]),
      ),
    );
  }
}

class AddPollOptionAlerDialog extends StatefulWidget {
  const AddPollOptionAlerDialog({super.key, required this.onSubmit});

  final Function(String newVotingOption) onSubmit;

  @override
  State<AddPollOptionAlerDialog> createState() =>
      _AddPollOptionAlerDialogState();
}

class _AddPollOptionAlerDialogState extends State<AddPollOptionAlerDialog> {
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomFormField(
        textEditingController: _descriptionController,
        hintText: AppLocalizations.of(context).voting_option_description,
      ),
      actions: [
        OutlinedButton(
            onPressed: () {
              widget.onSubmit(_descriptionController.text);
            },
            child: Text(AppLocalizations.of(context).add_vote_option)),
      ],
    );
  }
}

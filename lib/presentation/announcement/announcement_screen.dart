import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/announcement/announcement_cubit.dart';
import 'package:priorli/presentation/announcement/announcement_state.dart';
import 'package:priorli/presentation/file_selector/file_selector.dart';
import 'package:priorli/service_locator.dart';

import 'announcement_item.dart';

const announcementPath = 'announcements';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final cubit = serviceLocator<AnnouncementCubit>();
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.extentAfter < (cubit.state.total ?? 10)) {
          cubit.loadMore();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    cubit.close();
  }

  _getInitialData() async {
    final housingCompanyId =
        Uri.parse(GoRouter.of(context).location).pathSegments[1];
    await cubit.init(housingCompanyId);
  }

  @override
  Widget build(BuildContext context) {
    final housingCompanyId =
        Uri.parse(GoRouter.of(context).location).pathSegments[1];
    return BlocProvider<AnnouncementCubit>(
      create: (_) => cubit,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) {
                  return MakeAnnouncementDialog(
                    onSubmit: (
                        {required body,
                        required subtitle,
                        required title,
                        required sendEmail,
                        uploadedDocuments}) {
                      cubit.addAnnouncement(
                          sendEmail: sendEmail,
                          storageItems: uploadedDocuments,
                          title: title,
                          subtitle: subtitle,
                          body: body);
                      Navigator.pop(context, true);
                    },
                  );
                });
          },
        ),
        appBar: AppBar(
          title: const Text('Announcement'),
        ),
        body: BlocBuilder<AnnouncementCubit, AnnouncementState>(
            builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => cubit.init(housingCompanyId),
            child: ListView.builder(
                controller: _controller,
                itemCount: state.announcementList?.length ?? 0,
                itemBuilder: (context, index) {
                  final announcement = state.announcementList?[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: announcement != null
                        ? AnnouncementItem(
                            companyId: housingCompanyId,
                            announcement: announcement,
                          )
                        : const SizedBox.shrink(),
                  );
                }),
          );
        }),
      ),
    );
  }
}

class MakeAnnouncementDialog extends StatefulWidget {
  const MakeAnnouncementDialog({super.key, required this.onSubmit});
  final Function(
      {required String title,
      required String subtitle,
      required String body,
      required bool sendEmail,
      List<String>? uploadedDocuments}) onSubmit;

  @override
  State<MakeAnnouncementDialog> createState() => _MakeAnnouncementDialogState();
}

class _MakeAnnouncementDialogState extends State<MakeAnnouncementDialog> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _sendEmail = false;
  List<String> _uploadedDocuments = [];
  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.95,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                Text(
                  'Make announcement to housing company',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _titleController,
                    maxLines: 1,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _subtitleController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Subtitle',
                    ),
                  ),
                ),
                TextFormField(
                  controller: _bodyController,
                  minLines: 5,
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ),
                FileSelector(
                  onCompleteUploaded: (onCompleteUploaded) {
                    setState(() {
                      _uploadedDocuments = onCompleteUploaded;
                    });
                  },
                  autoUpload: true,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: _sendEmail,
                        onChanged: (onChanged) {
                          setState(() {
                            _sendEmail = !_sendEmail;
                          });
                        }),
                    const Text('Also send email'),
                    const Spacer(),
                    OutlinedButton(
                        onPressed: () {
                          widget.onSubmit(
                              sendEmail: _sendEmail,
                              body: _bodyController.text,
                              subtitle: _subtitleController.text,
                              title: _titleController.text,
                              uploadedDocuments: _uploadedDocuments);
                        },
                        child: const Text('Submit'))
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}

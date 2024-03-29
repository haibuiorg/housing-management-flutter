import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/admin/admin_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:priorli/presentation/admin/admin_state.dart';
import 'package:priorli/presentation/message/message_screen.dart';
import 'package:priorli/presentation/public/chat_public_screen.dart';

import '../file_selector/file_selector.dart';
import '../shared/conversation_item.dart';
import '../shared/custom_form_field.dart';

class GenericChatbotManagement extends StatelessWidget {
  const GenericChatbotManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              useSafeArea: true,
              context: context,
              builder: (builder) {
                return FractionallySizedBox(
                    heightFactor: 0.95,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            Center(
                                child: Container(
                              margin: const EdgeInsets.all(12),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  borderRadius: BorderRadius.circular(8)),
                            )),
                            const Expanded(
                                child: ChatPublicScreen(
                              isAdminChat: true,
                            )),
                          ],
                        )));
              });
        },
        label: const Text("Start conversation with AI"),
        icon: const Icon(Icons.android_rounded),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return AddDocIndexDialog(onComplete: (text) {
                          BlocProvider.of<AdminCubit>(context)
                              .addDocumentIndex(indexName: text)
                              .then((value) => Navigator.pop(builder));
                        });
                      });
                },
                child: const Text("Add index")),
            const DocumentIndexList(),
            const Divider(),
            const AdminBotConversation(),
          ],
        ),
      ),
    );
  }
}

class AdminBotConversation extends StatelessWidget {
  const AdminBotConversation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(builder: (context, state) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: state.adminBotConversationList?.length ?? 0,
          itemBuilder: (context, index) {
            final conversation = state.adminBotConversationList?[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: conversation != null
                  ? ConversationItem(
                      onPressed: () => GoRouter.of(context).push(
                          '$messagePath/${conversation.type}/${conversation.channelId}/${conversation.id}'),
                      conversation: conversation,
                    )
                  : const SizedBox.shrink(),
            );
          });
    });
  }
}

class DocumentIndexList extends StatelessWidget {
  const DocumentIndexList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(builder: (context, state) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: state.documentIndexes?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(state.documentIndexes![index]),
              trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (builder) => AddReferenceDocDialog(
                              indexName: state.documentIndexes![index],
                              onComplete: (
                                  {docType,
                                  required files,
                                  required indexName}) {
                                BlocProvider.of<AdminCubit>(context)
                                    .addGenericReferenceDoc(
                                        docType: docType,
                                        files: files,
                                        indexName: indexName)
                                    .then((value) => Navigator.pop(builder));
                              },
                            ));
                  },
                  icon: const Icon(Icons.upload_file)),
            );
          });
    });
  }
}

class AddReferenceDocDialog extends StatefulWidget {
  const AddReferenceDocDialog({
    super.key,
    required this.indexName,
    required this.onComplete,
  });
  final String indexName;
  final Function(
      {String? docType,
      required List<String> files,
      required String indexName}) onComplete;

  @override
  State<AddReferenceDocDialog> createState() => _AddReferenceDocDialogState();
}

class _AddReferenceDocDialogState extends State<AddReferenceDocDialog> {
  final TextEditingController _docTypeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _docTypeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomFormField(
              hintText: 'Doc type', textEditingController: _docTypeController),
          FileSelector(
              isSingleFile: true,
              onCompleteUploaded: (onCompleteUploaded) {
                if (onCompleteUploaded.isNotEmpty == true) {
                  widget.onComplete(
                      docType: _docTypeController.text.isNotEmpty
                          ? _docTypeController.text
                          : null,
                      files: onCompleteUploaded,
                      indexName: widget.indexName);
                }
              }),
        ],
      ),
    );
  }
}

class AddDocIndexDialog extends StatefulWidget {
  const AddDocIndexDialog({super.key, required this.onComplete});
  final Function(String) onComplete;

  @override
  State<AddDocIndexDialog> createState() => _AddDocIndexDialogState();
}

class _AddDocIndexDialogState extends State<AddDocIndexDialog> {
  final TextEditingController _indexNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _indexNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomFormField(
        hintText: AppLocalizations.of(context)!.name_title,
        textEditingController: _indexNameController,
        autofocus: false,
        keyboardType: TextInputType.name,
      ),
      actions: [
        TextButton(
            onPressed: () {
              widget.onComplete(_indexNameController.text);
            },
            child: Text(
              AppLocalizations.of(context)!.add,
            )),
      ],
    );
  }
}

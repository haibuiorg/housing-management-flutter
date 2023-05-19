import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/admin/admin_cubit.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:priorli/presentation/admin/admin_state.dart';

import '../file_selector/file_selector.dart';
import '../shared/custom_form_field.dart';

class GenericChatbotManagement extends StatelessWidget {
  const GenericChatbotManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
        ),
      ),
    );
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
  });
  final String indexName;

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
                  BlocProvider.of<AdminCubit>(context)
                      .addGenericReferenceDoc(
                        indexName: widget.indexName,
                        files: onCompleteUploaded,
                        docType: _docTypeController.text,
                      )
                      .then((value) => Navigator.pop(context));
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

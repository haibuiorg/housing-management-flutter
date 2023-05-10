import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/documents/document_list_screen_cubit.dart';
import 'package:priorli/presentation/documents/document_list_screen_state.dart';
import 'package:priorli/presentation/file_selector/file_selector.dart';
import 'package:priorli/presentation/shared/document_detail_dialog.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import 'package:priorli/service_locator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const documentListScreenPath = 'documents';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen(
      {super.key, required this.companyId, this.apartmentId});
  final String companyId;
  final String? apartmentId;

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  late final DocumentListScreenCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<DocumentListScreenCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  _getInitialData() async {
    if (widget.apartmentId != null) {
      await _cubit.init(widget.companyId, widget.apartmentId);
      return;
    }
    await _cubit.init(widget.companyId, null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DocumentListScreenCubit>(
        create: (_) => _cubit,
        child: Scaffold(
          body: BlocConsumer<DocumentListScreenCubit, DocumentListScreenState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context)!.documents),
                  ),
                  floatingActionButton: state.addDocument == true
                      ? FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (builder) => Dialog(
                                      child: FileSelector(
                                        onCompleteUploaded:
                                            (tempUploadedFiles) {
                                          _cubit
                                              .uploadNewFile(tempUploadedFiles)
                                              .then((value) =>
                                                  Navigator.pop(builder));
                                        },
                                      ),
                                    ));
                          },
                        )
                      : null,
                  body: ListView.builder(
                      itemCount: (state.documentList?.length ?? 0) + 1,
                      itemBuilder: (context, index) {
                        return index < (state.documentList?.length ?? 0)
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SettingButton(
                                  onPressed: () {
                                    _cubit
                                        .getDocument(
                                            state.documentList?[index].id ?? '')
                                        .then((value) => showDialog(
                                            context: context,
                                            builder: (builder) =>
                                                DocumentDetailDialog(
                                                  document: value!,
                                                )));
                                  },
                                  label: Text(
                                    state.documentList?[index].name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            : TextButton(
                                onPressed: () {
                                  _cubit.loadMore();
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.load_more));
                      }),
                );
              }),
        ));
  }
}

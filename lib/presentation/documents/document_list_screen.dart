import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/documents/document_list_screen_cubit.dart';
import 'package:priorli/presentation/documents/document_list_screen_state.dart';
import 'package:priorli/presentation/file_selector/file_selector.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import 'package:priorli/service_locator.dart';

import '../shared/app_gallery.dart';

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
                    title: const Text('Documents'),
                  ),
                  floatingActionButton: state.addDocument == true
                      ? FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: FileSelector(
                                        onCompleteUploaded:
                                            (tempUploadedFiles) {
                                          _cubit
                                              .uploadNewFile(tempUploadedFiles);
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
                                        .then((value) => showBottomSheet(
                                            context: context,
                                            builder: (builder) => AppGallery(
                                                galleryItems: value != null
                                                    ? [value]
                                                    : [])));
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
                                child: const Text('Load more'));
                      }),
                );
              }),
        ));
  }
}

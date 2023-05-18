import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/admin/admin_cubit.dart';

import '../file_selector/file_selector.dart';

class GenericChatbotManagement extends StatelessWidget {
  const GenericChatbotManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return AlertDialog(
                          content: const Text('Add new index'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  BlocProvider.of<AdminCubit>(context)
                                      .addDocumentIndex(
                                          indexName: "housing-company-generic")
                                      .then((value) => Navigator.pop(builder));
                                },
                                child: const Text("Add")),
                          ],
                        );
                      });
                },
                child: const Text("Add index")),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (builder) => Dialog(
                            child: FileSelector(
                                isSingleFile: true,
                                onCompleteUploaded: (onCompleteUploaded) {
                                  if (onCompleteUploaded.isNotEmpty == true) {
                                    BlocProvider.of<AdminCubit>(context)
                                        .addGenericReferenceDoc(
                                            onCompleteUploaded)
                                        .then(
                                            (value) => Navigator.pop(builder));
                                  }
                                }),
                          ));
                },
                child: const Text("Add document")),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/documents/document_list_screen_cubit.dart';
import 'package:priorli/presentation/documents/document_list_screen_state.dart';
import 'package:priorli/service_locator.dart';

const documentScreenPath = 'document';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DocumentListScreenCubit>(
        create: (_) => serviceLocator<DocumentListScreenCubit>(),
        child: BlocConsumer<DocumentListScreenCubit, DocumentListScreenState>(
            listener: (context, state) {},
            builder: (context, state) {
              return const Scaffold();
            }));
  }
}

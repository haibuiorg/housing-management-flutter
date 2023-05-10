import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/storage/entities/storage_item.dart';
import '../../setting_cubit.dart';
import 'app_gallery.dart';

class DocumentDetailDialog extends StatelessWidget {
  const DocumentDetailDialog({
    super.key,
    required this.document,
  });

  final StorageItem document;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        children: [
          AppGallery(galleryItems: [document]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(16.0),
              child: Text(document.summaryTranslation
                      ?.firstWhere((element) =>
                          element.languageCode ==
                          BlocProvider.of<SettingCubit>(context)
                              .state
                              .languageCode)
                      .value ??
                  ''),
            ),
          ),
        ],
      ),
    );
  }
}

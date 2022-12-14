import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:priorli/core/utils/file_extension.dart';
import 'package:priorli/presentation/file_selector/file_selector_clear_controller.dart';
import 'package:priorli/presentation/file_selector/file_selector_cubit.dart';
import 'package:priorli/presentation/file_selector/file_selector_state.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/service_locator.dart';
import 'package:path/path.dart' as p;
import 'package:carousel_slider/carousel_slider.dart';

class FileSelector extends StatefulWidget {
  const FileSelector(
      {super.key,
      required this.onCompleteUploaded,
      this.isSingleFile = false,
      this.isImageOnly = false,
      this.previewUrl,
      this.autoUpload = false,
      this.fileSelectorController});
  final String? previewUrl;
  final bool isSingleFile;
  final bool isImageOnly;
  final bool autoUpload;
  final Function(List<String> tempUploadedFiles) onCompleteUploaded;
  final FileSelectorClearController? fileSelectorController;

  @override
  State<FileSelector> createState() => _FileSelectorState();
}

class _FileSelectorState extends State<FileSelector> {
  late final FileSelectorCubit _cubit;
  @override
  void initState() {
    widget.fileSelectorController?.addListener(() {
      _cubit.clearSelectedFiles();
    });
    _cubit = serviceLocator<FileSelectorCubit>()..init(widget.autoUpload);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FileSelectorCubit>(
      create: (_) => _cubit,
      child: BlocConsumer<FileSelectorCubit, FileSelectorState>(
          listener: (context, state) {
        if (state.uploadedLocations?.isNotEmpty == true || widget.autoUpload) {
          print(state);
          widget.onCompleteUploaded(state.uploadedLocations ?? []);
        }
      }, builder: (context, state) {
        return state.uploading == true
            ? Container(
                height: 100,
                width: 100,
                padding: const EdgeInsets.all(16),
                child: const AppLottieAnimation(
                  loadingResource: 'uploading',
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (state.selectedFiles?.isNotEmpty == true ||
                          widget.previewUrl?.isNotEmpty == true)
                      ? CarouselSlider.builder(
                          itemCount: state.selectedFiles?.length ?? 0,
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.width / 2,
                              viewportFraction: 0.5,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                              aspectRatio: 1),
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              state.selectedFiles?.isNotEmpty == true
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 16),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    onError: (exception,
                                                        stackTrace) {},
                                                    image: FileImage(
                                                        state.selectedFiles![
                                                            itemIndex]))),
                                            child: !state
                                                    .selectedFiles![itemIndex]
                                                    .isImage
                                                ? const AppLottieAnimation(
                                                    loadingResource:
                                                        'documents',
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                p.basename(state
                                                    .selectedFiles![itemIndex]
                                                    .path),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              FileSelectorCubit>(
                                                          context)
                                                      .removeFilesByPosition(
                                                          itemIndex);
                                                },
                                                icon: const Icon(Icons.close))
                                          ],
                                        ),
                                      ],
                                    )
                                  : widget.previewUrl?.isNotEmpty == true
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: CachedNetworkImage(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            imageUrl: widget.previewUrl ?? '',
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                        )
                      : const SizedBox.shrink(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !widget.isImageOnly
                          ? IconButton(
                              onPressed: widget.isSingleFile &&
                                      (state.selectedFiles?.length ?? 0) > 0
                                  ? null
                                  : () async {
                                      final cubit =
                                          BlocProvider.of<FileSelectorCubit>(
                                              context);
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                              allowMultiple:
                                                  !widget.isSingleFile);
                                      if (result != null) {
                                        List<File> files = result.paths
                                            .map((path) => File(path!))
                                            .toList();
                                        await cubit.loadFiles(files);
                                      }
                                    },
                              icon: const Icon(Icons.file_open),
                            )
                          : const SizedBox.shrink(),
                      IconButton(
                        icon: const Icon(Icons.photo),
                        onPressed: widget.isSingleFile &&
                                (state.selectedFiles?.length ?? 0) > 0
                            ? null
                            : () async {
                                final cubit =
                                    BlocProvider.of<FileSelectorCubit>(context);
                                final ImagePicker picker = ImagePicker();
                                if (widget.isSingleFile) {
                                  final file = await picker.pickImage(
                                      imageQuality: 50,
                                      source: ImageSource.gallery);
                                  if (file != null) {
                                    await cubit.loadFiles([File(file.path)]);
                                  }
                                } else {
                                  final List<XFile> results = await picker
                                      .pickMultiImage(imageQuality: 50);
                                  List<File> files = results
                                      .map((result) => File(result.path))
                                      .toList();
                                  await cubit.loadFiles(files);
                                }
                              },
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt_rounded),
                        onPressed: widget.isSingleFile &&
                                (state.selectedFiles?.length ?? 0) > 0
                            ? null
                            : () async {
                                final cubit =
                                    BlocProvider.of<FileSelectorCubit>(context);
                                final ImagePicker picker = ImagePicker();
                                final file = await picker.pickImage(
                                    imageQuality: 50,
                                    source: ImageSource.camera);
                                if (file != null) {
                                  await cubit.loadFiles([File(file.path)]);
                                }
                              },
                      ),
                      !widget.autoUpload
                          ? Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.upload_file_rounded),
                                label: const Text('Upload'),
                                onPressed: (state.selectedFiles?.length ?? 0) >
                                        0
                                    ? (() => BlocProvider.of<FileSelectorCubit>(
                                            context)
                                        .uploadAllFiles())
                                    : null,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ],
              );
      }),
    );
    ;
  }
}

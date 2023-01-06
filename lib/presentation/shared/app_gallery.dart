import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';
import 'package:priorli/presentation/shared/pdf_viewer.dart';

class AppGallery extends StatefulWidget {
  const AppGallery({super.key, required this.galleryItems});
  final List<StorageItem> galleryItems;

  @override
  State<AppGallery> createState() => _AppGalleryState();
}

class _AppGalleryState extends State<AppGallery> {
  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          errorBuilder: (context, error, stackTrace) {
            return PdfViewer(
                link: widget.galleryItems[index].presignedUrl ?? '');
          },
          imageProvider:
              NetworkImage(widget.galleryItems[index].presignedUrl ?? ''),
          initialScale: PhotoViewComputedScale.contained * 0.8,
          heroAttributes: PhotoViewHeroAttributes(
              tag: widget.galleryItems[index].id ?? index),
        );
      },
      backgroundDecoration:
          BoxDecoration(borderRadius: BorderRadius.circular(16)),
      itemCount: widget.galleryItems.length,
      loadingBuilder: (context, event) => Center(
        child: SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:priorli/core/storage/entities/storage_item.dart';

import 'app_gallery.dart';
import 'app_lottie_animation.dart';

class AppImageRow extends StatelessWidget {
  const AppImageRow({super.key, this.storageItems});
  final List<StorageItem>? storageItems;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: storageItems?.isNotEmpty == true
          ? SizedBox(
              height: 100,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: storageItems?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CachedNetworkImage(
                        errorWidget: (context, url, error) {
                          return SizedBox(
                            width: 100,
                            height: 100,
                            child: InkWell(
                              onTap: () {
                                showBottomSheet(
                                    context: context,
                                    builder: (builder) => AppGallery(
                                        galleryItems: storageItems ?? []));
                              },
                              child: const AppLottieAnimation(
                                loadingResource: 'documents',
                              ),
                            ),
                          );
                        },
                        imageBuilder: (context, imageProvider) {
                          return InkWell(
                            onTap: () {
                              showBottomSheet(
                                  context: context,
                                  builder: (builder) => AppGallery(
                                      galleryItems: storageItems ?? []));
                            },
                            child: Center(
                              child: Container(
                                width: 150,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: imageProvider),
                                ),
                              ),
                            ),
                          );
                        },
                        imageUrl: storageItems?[index].presignedUrl ?? ''),
                  );
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

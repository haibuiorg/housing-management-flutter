import 'dart:io';
import 'package:mime/mime.dart';

extension FileExtension on File {
  bool get isImage {
    final mimeType = lookupMimeType(path);

    return mimeType?.startsWith('image/') == true;
  }
}

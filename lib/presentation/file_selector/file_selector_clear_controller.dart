import 'dart:io';

import 'package:flutter/material.dart';

class FileSelectorClearController extends ChangeNotifier {
  FileSelectorClearController();
  clearFiles() {
    notifyListeners();
  }
}

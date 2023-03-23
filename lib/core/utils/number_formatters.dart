import 'dart:math';

import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    var regex = RegExp(r'[^0-9\.\,]');
    final String original = newValue.text.replaceAll(regex, '');
    String truncated = original.replaceAll(",", ".");

    String value = original.replaceAll(",", ".");

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
    } else if (value == ".") {
      truncated = "0.";
    }

    return TextEditingValue(
      text: truncated,
      selection:
          TextSelection.fromPosition(TextPosition(offset: truncated.length)),
      composing: TextRange.empty,
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:universal_io/io.dart' as universal_platform;

extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.+]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    return length > 6;
  }

  bool get isValidBic {
    final reg = RegExp('^[A-Z]{6}[A-Z0-9]{2}([A-Z0-9]{3})?');
    return reg.hasMatch(toUpperCase());
  }

  bool get isValidPhone {
    final phoneRegExp =
        RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)');
    return phoneRegExp.hasMatch(this);
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String camelCaseToUnderScore() {
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    String result =
        replaceAllMapped(exp, (Match m) => ('_${m.group(0)}')).toLowerCase();
    return result;
  }
}

String formatCurrency(double? amount, String? currencyCode) {
  if (amount == null || currencyCode == null) {
    return '';
  }
  try {
    return NumberFormat.simpleCurrency(
            locale: universal_platform.Platform.localeName,
            name: currencyCode.toUpperCase())
        .format(amount);
  } catch (error) {
    debugPrint(error.toString());
    return '';
  }
}

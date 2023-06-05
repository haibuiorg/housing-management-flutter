import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {Key? key,
      required this.hintText,
      this.inputFormatters,
      this.validator,
      this.textEditingController,
      this.autoValidate = false,
      this.icon,
      this.onSubmitted,
      this.obscureText = false,
      this.keyboardType,
      this.helperText,
      this.onChanged,
      this.textInputAction,
      this.initialValue,
      this.focusNode,
      this.autofocus,
      this.textCapitalization,
      this.decoration,
      this.enabled})
      : super(key: key);
  final String hintText;
  final String? helperText;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController? textEditingController;
  final bool autoValidate;
  final Widget? icon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final String? initialValue;
  final FocusNode? focusNode;
  final bool? autofocus;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization? textCapitalization;
  final InputDecoration? decoration;
  final bool? enabled;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        autovalidateMode: autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        controller: textEditingController,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        inputFormatters: inputFormatters,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        initialValue: initialValue,
        focusNode: focusNode,
        autofocus: autofocus ?? true,
        textInputAction: textInputAction,
        onFieldSubmitted: onSubmitted,
        decoration: decoration?.copyWith(
                hintText: hintText,
                icon: icon,
                helperText: helperText,
                helperMaxLines: 3,
                errorStyle: const TextStyle(inherit: true)) ??
            InputDecoration(
                hintText: hintText,
                icon: icon,
                helperText: helperText,
                helperMaxLines: 3,
                errorStyle: const TextStyle(inherit: true)),
      ),
    );
  }
}

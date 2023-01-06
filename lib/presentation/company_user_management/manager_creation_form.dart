import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ManagerCreationForm extends StatefulWidget {
  const ManagerCreationForm({
    super.key,
    required this.onSubmit,
  });
  final Function({
    required String email,
    String? firstName,
    String? lastname,
    String? phone,
  }) onSubmit;

  @override
  State<ManagerCreationForm> createState() => _ManagerCreationFormState();
}

class _ManagerCreationFormState extends State<ManagerCreationForm> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastnameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  _submit() {
    widget.onSubmit(
        firstName: _firstNameController.text,
        lastname: _lastnameController.text,
        phone: _phoneController.text,
        email: _emailController.text);
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastnameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResponsiveRowColumn(
            rowMainAxisSize: MainAxisSize.min,
            rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
            layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: CustomFormField(
                  hintText: 'Email',
                  textEditingController: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: CustomFormField(
                  hintText: 'First name',
                  textEditingController: _firstNameController,
                  keyboardType: TextInputType.name,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: CustomFormField(
                  hintText: 'Last name',
                  textEditingController: _lastnameController,
                  keyboardType: TextInputType.name,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: CustomFormField(
                  hintText: 'Phone',
                  textEditingController: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                ? ResponsiveRowColumnItem(
                    rowFit: FlexFit.loose,
                    child: TextButton(
                      onPressed: _submit,
                      child: const Text('Add'),
                    ))
                : ResponsiveRowColumnItem(
                    rowFit: FlexFit.loose,
                    child: IconButton(
                      onPressed: _submit,
                      icon: const Icon(Icons.arrow_forward_rounded),
                    )),
          )
        ],
      ),
    );
  }
}
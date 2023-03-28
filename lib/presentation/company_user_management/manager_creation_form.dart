import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                  hintText: AppLocalizations.of(context).email,
                  textEditingController: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: CustomFormField(
                  hintText: AppLocalizations.of(context).first_name,
                  textEditingController: _firstNameController,
                  keyboardType: TextInputType.name,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: CustomFormField(
                  hintText: AppLocalizations.of(context).last_name,
                  textEditingController: _lastnameController,
                  keyboardType: TextInputType.name,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                child: CustomFormField(
                  hintText: AppLocalizations.of(context).phone_number,
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
              child: ResponsiveValue<Widget>(context,
                  defaultValue: ResponsiveRowColumnItem(
                      rowFit: FlexFit.loose,
                      child: TextButton(
                        onPressed: _submit,
                        child: Text(AppLocalizations.of(context).add),
                      )),
                  valueWhen: [
                    Condition.largerThan(
                        name: MOBILE,
                        value: ResponsiveRowColumnItem(
                          rowFit: FlexFit.loose,
                          child: TextButton(
                            onPressed: _submit,
                            child: Text(AppLocalizations.of(context).add),
                          ),
                        )),
                    Condition.smallerThan(
                        name: TABLET,
                        value: ResponsiveRowColumnItem(
                            rowFit: FlexFit.loose,
                            child: IconButton(
                              onPressed: _submit,
                              icon: const Icon(Icons.arrow_forward_rounded),
                            )))
                  ]).value)
        ],
      ),
    );
  }
}

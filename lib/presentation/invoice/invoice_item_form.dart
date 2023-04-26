import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InvoiceItemForm extends StatefulWidget {
  const InvoiceItemForm({
    super.key,
    required this.onTypingInvoiceItem,
  });
  final Function(
      {required String name,
      required String description,
      required double price,
      required double quantity,
      required double taxPercentage,
      required double total}) onTypingInvoiceItem;

  @override
  State<InvoiceItemForm> createState() => _InvoiceItemFormState();
}

class _InvoiceItemFormState extends State<InvoiceItemForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;
  late final TextEditingController _taxController;
  double _total = 0;

  _submit() {
    widget.onTypingInvoiceItem(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(
              _priceController.text,
            ) ??
            0,
        quantity: double.tryParse(_quantityController.text) ?? 0,
        taxPercentage: double.tryParse(_taxController.text) ?? 0,
        total: _total);
  }

  _calculateTotal() {
    final price = double.tryParse(
          _priceController.text,
        ) ??
        0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final taxPercentage = double.tryParse(_taxController.text) ?? 0;
    setState(() {
      _total = price * quantity * ((taxPercentage + 100) / 100);
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _taxController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _taxController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResponsiveRowColumn(
          rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
          layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 2,
              child: CustomFormField(
                hintText: AppLocalizations.of(context)!.item_name,
                textEditingController: _nameController,
              ),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 2,
              child: CustomFormField(
                hintText: AppLocalizations.of(context)!.item_description,
                textEditingController: _descriptionController,
              ),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: CustomFormField(
                hintText: AppLocalizations.of(context)!.unit_price,
                textEditingController: _priceController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _calculateTotal(),
              ),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: CustomFormField(
                hintText: AppLocalizations.of(context)!.quantity,
                textEditingController: _quantityController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _calculateTotal(),
              ),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: CustomFormField(
                hintText: AppLocalizations.of(context)!.tax_rate,
                textEditingController: _taxController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _calculateTotal(),
              ),
            ),
            ResponsiveRowColumnItem(
                rowFlex: 1,
                child: Text(
                  AppLocalizations.of(context)!
                      .total_value(_total.toStringAsFixed(2)),
                )),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? ResponsiveRowColumnItem(
                  rowFit: FlexFit.loose,
                  child: TextButton(
                    onPressed: _submit,
                    child: Text(AppLocalizations.of(context)!.add_item),
                  ))
              : ResponsiveRowColumnItem(
                  rowFit: FlexFit.loose,
                  child: IconButton(
                    onPressed: _submit,
                    icon: const Icon(Icons.arrow_forward_rounded),
                  )),
        )
      ],
    );
  }
}

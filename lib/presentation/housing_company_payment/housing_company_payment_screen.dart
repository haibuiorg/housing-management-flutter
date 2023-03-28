import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/housing_company_payment/housing_company_payment_cubit.dart';
import 'package:priorli/presentation/housing_company_payment/housing_company_payment_state.dart';
import 'package:iban/iban.dart';
import '../../service_locator.dart';
import '../shared/custom_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const housingCompanyPaymentPath = 'payment';

class HousingCompanyPaymentScreen extends StatefulWidget {
  const HousingCompanyPaymentScreen({super.key, required this.companyId});
  final String companyId;

  @override
  State<HousingCompanyPaymentScreen> createState() =>
      _HousingCompanyPaymentScreenState();
}

class _HousingCompanyPaymentScreenState
    extends State<HousingCompanyPaymentScreen> {
  final HousingCompanyPaymentCubit cubit =
      serviceLocator<HousingCompanyPaymentCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  _getInitialData() async {
    cubit.init(widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HousingCompanyPaymentCubit>(
      create: (_) => cubit,
      child:
          BlocConsumer<HousingCompanyPaymentCubit, HousingCompanyPaymentState>(
        listener: (context, state) {
          if (state.newBankAccountAdded == true) {
            Navigator.pop(context, true);
            cubit.bankAccountDialogDismissed();
          }
        },
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton.small(
                child: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (builder) {
                        return AddBankAccountDialog(onSubmit: (
                            {required bankAccountNumber,
                            required swift}) async {
                          cubit
                              .addNewBankAccount(
                                  bankAccountNumber: bankAccountNumber,
                                  swift: swift)
                              .then((value) => Navigator.pop(builder));
                        });
                      });
                }),
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppLocalizations.of(context).payment_bank_account),
            ),
            body: ListView.builder(
                itemCount: state.bankAccountList?.length ?? 0,
                itemBuilder: (context, index) {
                  return BankAccountBox(
                    bankAccount: state.bankAccountList?[index] ??
                        const BankAccount(
                            swift: '',
                            bankAccountNumber: '',
                            id: '',
                            isDeleted: true,
                            housingCompanyId: ''),
                    onDismiss: () => cubit.removeBankAccount(
                        bankAccountId: state.bankAccountList?[index].id ?? ''),
                  );
                }),
          );
        },
      ),
    );
  }
}

class BankAccountBox extends StatelessWidget {
  const BankAccountBox(
      {super.key, required this.onDismiss, required this.bankAccount});
  final Function() onDismiss;
  final BankAccount bankAccount;

  _showConfirmDeleteDialog(BuildContext context, Function() onDismiss) async {
    showDialog(
      context: context,
      builder: (BuildContext builder) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).delete_bank_account),
          content:
              Text(AppLocalizations.of(context).delete_bank_account_confirm),
          actions: [
            OutlinedButton(
                onPressed: onDismiss,
                child: Text(AppLocalizations.of(context).remove)),
            TextButton(
              onPressed: () => Navigator.of(builder).pop(false),
              child: Text(AppLocalizations.of(context).cancel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(width: 0.5)),
        trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showConfirmDeleteDialog(context, () {
                  onDismiss();
                  Navigator.of(context).pop(true);
                })),
        onLongPress: () => _showConfirmDeleteDialog(context, onDismiss),
        title: Text(bankAccount.bankAccountNumber),
        subtitle: Text(bankAccount.swift),
      ),
    );
  }
}

class AddBankAccountDialog extends StatefulWidget {
  const AddBankAccountDialog({super.key, required this.onSubmit});
  final Function({
    required String bankAccountNumber,
    required String swift,
  }) onSubmit;

  @override
  State<AddBankAccountDialog> createState() => _AddBankAccountDialogState();
}

class _AddBankAccountDialogState extends State<AddBankAccountDialog> {
  final _bankAccountNumberController = TextEditingController();
  final _swiftController = TextEditingController();
  bool _valid = false;

  didChange() {
    setState(() {
      _valid = _swiftController.text.isValidBic &&
          _bankAccountNumberController.text.trim().isNotEmpty == true &&
          isValid(_bankAccountNumberController.text, sanitize: true);
    });
  }

  @override
  void dispose() {
    _bankAccountNumberController.dispose();
    _swiftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).add_bank_account),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomFormField(
          autofocus: false,
          autoValidate: true,
          hintText: AppLocalizations.of(context).iban,
          textEditingController: _bankAccountNumberController,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            didChange();
          },
          textInputAction: TextInputAction.next,
          validator: (val) {
            return val?.trim().isNotEmpty == true &&
                    !isValid(val!, sanitize: true)
                ? AppLocalizations.of(context).iban_error
                : null;
          },
        ),
        CustomFormField(
          autofocus: false,
          autoValidate: true,
          hintText: AppLocalizations.of(context).bic_swift,
          onChanged: (value) {
            didChange();
          },
          textEditingController: _swiftController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          validator: (val) {
            return !val!.isValidBic
                ? AppLocalizations.of(context).bic_swift_error
                : null;
          },
        ),
      ]),
      actions: [
        OutlinedButton(
            onPressed: _valid
                ? () {
                    widget.onSubmit(
                        bankAccountNumber: _bankAccountNumberController.text,
                        swift: _swiftController.text);
                  }
                : null,
            child: Text(AppLocalizations.of(context).add)),
      ],
    );
  }
}

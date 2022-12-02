import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/housing_company_payment/housing_company_payment_cubit.dart';
import 'package:priorli/presentation/housing_company_payment/housing_company_payment_state.dart';
import 'package:iban/iban.dart';
import '../../service_locator.dart';
import '../shared/custom_form_field.dart';

const housingCompanyPaymentPath = 'payment';

class HousingCompanyPaymentScreen extends StatefulWidget {
  const HousingCompanyPaymentScreen({super.key});

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
    final housingCompanyId =
        Uri.parse(GoRouter.of(context).location).pathSegments[1];
    cubit.init(housingCompanyId);
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
                      builder: (context) {
                        return AddBankAccountDialog(onSubmit: (
                            {required bankAccountNumber,
                            required swift}) async {
                          cubit.addNewBankAccount(
                              bankAccountNumber: bankAccountNumber,
                              swift: swift);
                        });
                      });
                }),
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Payments'),
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content:
              const Text("Are you sure you wish to delete this bank account?"),
          actions: [
            OutlinedButton(onPressed: onDismiss, child: const Text("Delete")),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showConfirmDeleteDialog(context, () {
          Navigator.of(context).pop(true);
        });
      },
      onDismissed: (direction) => onDismiss,
      key: Key(bankAccount.id),
      child: Card(
        elevation: 4,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _showConfirmDeleteDialog(context, () {
                    onDismiss();
                    Navigator.of(context).pop(true);
                  }),
                ),
              ),
              Text(bankAccount.bankAccountNumber),
              Text(bankAccount.swift),
            ],
          ),
        ),
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
      title: const Text('Add new bank account detail'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomFormField(
          autofocus: false,
          autoValidate: true,
          hintText: "IBAN",
          textEditingController: _bankAccountNumberController,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            didChange();
          },
          textInputAction: TextInputAction.next,
          validator: (val) {
            return val?.trim().isNotEmpty == true &&
                    !isValid(val!, sanitize: true)
                ? 'Enter valid Iban'
                : null;
          },
        ),
        CustomFormField(
          autofocus: false,
          autoValidate: true,
          hintText: "BIC/SWIFT",
          onChanged: (value) {
            didChange();
          },
          textEditingController: _swiftController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          validator: (val) {
            return !val!.isValidBic ? 'Enter valid Bic or Swift code' : null;
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
            child: const Text('Submit'))
      ],
    );
  }
}

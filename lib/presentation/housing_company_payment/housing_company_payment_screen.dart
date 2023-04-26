import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/core/payment/entities/bank_account.dart';
import 'package:priorli/core/utils/string_extension.dart';
import 'package:priorli/presentation/housing_company_payment/housing_company_payment_cubit.dart';
import 'package:priorli/presentation/housing_company_payment/housing_company_payment_state.dart';
import 'package:iban/iban.dart';
import 'package:url_launcher/url_launcher.dart';
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
          if (state.connectPaymentAccountUrl != null) {
            launchUrl(Uri.parse(state.connectPaymentAccountUrl!));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppLocalizations.of(context)!.payment_bank_account),
            ),
            body: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      cubit.init(widget.companyId);
                    },
                    child: ListView.builder(
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
                              onDismiss: (context) {
                                cubit
                                    .removeBankAccount(
                                        bankAccountId:
                                            state.bankAccountList?[index].id ??
                                                '')
                                    .then((value) =>
                                        Navigator.of(context).pop(true));
                              });
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                          elevation: 2,
                          label: Text(
                              AppLocalizations.of(context)!.add_bank_account),
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return AddBankAccountDialog(onSubmit: (
                                      {required bankAccountNumber,
                                      required swift,
                                      String? bankAccountName}) async {
                                    cubit
                                        .addNewBankAccount(
                                            bankAccountNumber:
                                                bankAccountNumber,
                                            swift: swift)
                                        .then(
                                            (value) => Navigator.pop(builder));
                                  });
                                });
                          }),
                      FloatingActionButton.extended(
                          elevation: 2,
                          label: Text(AppLocalizations.of(context)!
                              .set_up_payout_account),
                          icon: const Icon(Icons.account_balance_rounded),
                          onPressed: () {
                            cubit.setupConnectPaymentAccount();
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BankAccountBox extends StatelessWidget {
  const BankAccountBox(
      {super.key, required this.onDismiss, required this.bankAccount});
  final Function(BuildContext context) onDismiss;
  final BankAccount bankAccount;

  _showConfirmDeleteDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext builder) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.delete_bank_account),
          content:
              Text(AppLocalizations.of(context)!.delete_bank_account_confirm),
          actions: [
            OutlinedButton(
                onPressed: () {
                  onDismiss(builder);
                },
                child: Text(AppLocalizations.of(context)!.remove)),
            TextButton(
              onPressed: () => Navigator.of(builder).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
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
            onPressed: () => _showConfirmDeleteDialog(
                  context,
                )),
        onLongPress: () => _showConfirmDeleteDialog(
          context,
        ),
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
    String? bankAccountName,
  }) onSubmit;

  @override
  State<AddBankAccountDialog> createState() => _AddBankAccountDialogState();
}

class _AddBankAccountDialogState extends State<AddBankAccountDialog> {
  final _bankAccountNameController = TextEditingController();
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
    _bankAccountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.add_bank_account),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        CustomFormField(
          autofocus: false,
          autoValidate: true,
          hintText: AppLocalizations.of(context)!.bank_account_name,
          textEditingController: _bankAccountNameController,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            didChange();
          },
          textInputAction: TextInputAction.next,
        ),
        CustomFormField(
          autofocus: false,
          autoValidate: true,
          hintText: AppLocalizations.of(context)!.iban,
          textEditingController: _bankAccountNumberController,
          keyboardType: TextInputType.text,
          onChanged: (value) {
            didChange();
          },
          textInputAction: TextInputAction.next,
          validator: (val) {
            return val?.trim().isNotEmpty == true &&
                    !isValid(val!, sanitize: true)
                ? AppLocalizations.of(context)!.iban_error
                : null;
          },
        ),
        CustomFormField(
          autofocus: false,
          autoValidate: true,
          hintText: AppLocalizations.of(context)!.bic_swift,
          onChanged: (value) {
            didChange();
          },
          textEditingController: _swiftController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          validator: (val) {
            return !val!.isValidBic
                ? AppLocalizations.of(context)!.bic_swift_error
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
            child: Text(AppLocalizations.of(context)!.add)),
      ],
    );
  }
}

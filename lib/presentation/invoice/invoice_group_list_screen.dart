import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/invoice/invoice_group_cubit.dart';
import 'package:priorli/presentation/invoice/invoice_group_state.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/presentation/shared/setting_button.dart';
import 'package:priorli/service_locator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../housing_company/housing_company_screen.dart';
import 'invoice_list_screen.dart';

const invoiceGroupPath = 'invoice_group';

class InvoiceGroupListScreen extends StatefulWidget {
  const InvoiceGroupListScreen({super.key, required this.companyId});
  final String companyId;

  @override
  State<InvoiceGroupListScreen> createState() => _InvoiceGroupListScreenState();
}

class _InvoiceGroupListScreenState extends State<InvoiceGroupListScreen> {
  late final InvoiceGroupCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<InvoiceGroupCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  _getInitialData() async {
    await _cubit.init(widget.companyId);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceGroupCubit>(
        create: (_) => _cubit,
        child: Scaffold(
          body: BlocConsumer<InvoiceGroupCubit, InvoiceGroupState>(
              listener: (context, state) {},
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context)!.invoice_groupd),
                  ),
                  floatingActionButton: state.company?.isUserManager == true
                      ? FloatingActionButton(
                          child: const Icon(Icons.add),
                          onPressed: () {},
                        )
                      : null,
                  body: state.company?.isUserManager == true
                      ? ListView.builder(
                          itemCount: (state.invoiceGroupList?.length ?? 0) + 1,
                          itemBuilder: (context, index) {
                            return index < (state.invoiceGroupList?.length ?? 0)
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SettingButton(
                                      onPressed: () {
                                        context.push(
                                            '/$housingCompanyScreenPath/${widget.companyId}/company/$invoiceListPath/${state.invoiceGroupList?[index].id}');
                                      },
                                      label: Text(
                                        state.invoiceGroupList?[index]
                                                .invoiceName ??
                                            '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                : TextButton(
                                    onPressed: () {
                                      _cubit.loadMore();
                                    },
                                    child: Text(AppLocalizations.of(context)!
                                        .load_more));
                          })
                      : const Center(
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: AppLottieAnimation(
                              loadingResource: 'invoice',
                            ),
                          ),
                        ),
                );
              }),
        ));
  }
}

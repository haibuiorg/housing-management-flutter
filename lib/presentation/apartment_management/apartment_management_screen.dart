import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_cubit.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_state.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';
import '../../go_router_navigation.dart';
import '../shared/setting_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ApartmentManagementScreen extends StatefulWidget {
  const ApartmentManagementScreen(
      {super.key, required this.apartmentId, required this.companyId});
  final String apartmentId;
  final String companyId;

  @override
  State<ApartmentManagementScreen> createState() =>
      _ApartmentManagementScreenState();
}

class _ApartmentManagementScreenState extends State<ApartmentManagementScreen> {
  late final ApartmentManagementCubit cubit;
  final _apartmentName = TextEditingController();
  final _houseCode = TextEditingController();

  @override
  void dispose() {
    _apartmentName.dispose();
    _houseCode.dispose();
    cubit.close();
    super.dispose();
  }

  _showConfirmDeleteDialog(
      Function(BuildContext builderContext) onDismiss) async {
    showDialog(
      context: context,
      builder: (BuildContext builderContext) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this apartment"),
          actions: [
            OutlinedButton(
                onPressed: onDismiss(builderContext),
                child: const Text("Delete")),
            TextButton(
              onPressed: () => Navigator.of(builderContext).pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    cubit = serviceLocator<ApartmentManagementCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  _getInitialData() async {
    final state = await cubit.init(widget.companyId, widget.apartmentId);
    _apartmentName.text = state.apartment?.building ?? '';
    _houseCode.text = state.apartment?.houseCode ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApartmentManagementCubit>(
      create: (_) => cubit,
      child: BlocConsumer<ApartmentManagementCubit, ApartmentManagementState>(
          listener: (context, state) {
        if (state.deleted == true) {
          Navigator.of(context)
              .popUntil(ModalRoute.withName(housingCompanyScreenPathName));
        }
      }, builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                  onPressed: state.apartment != state.pendingApartment
                      ? () {
                          cubit.saveNewApartmentInfo();
                        }
                      : null,
                  child: Text(AppLocalizations.of(context).save),
                )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        CustomFormField(
                          textEditingController: _apartmentName,
                          hintText: AppLocalizations.of(context).building_name,
                          autofocus: false,
                          onChanged: (value) =>
                              cubit.updateAparmentBuildingName(value),
                          keyboardType: TextInputType.name,
                        ),
                        CustomFormField(
                          hintText:
                              AppLocalizations.of(context).building_number,
                          textEditingController: _houseCode,
                          autofocus: false,
                          onChanged: (value) =>
                              cubit.updateApartmentHousecode(value),
                          keyboardType: TextInputType.streetAddress,
                        ),
                      ]),
                    ),
                  ),
                  SettingButton(
                    onPressed: () {
                      _showConfirmDeleteDialog((BuildContext builderContext) =>
                          cubit.deleteThisApartment().then(
                              (value) => Navigator.of(builderContext).pop()));
                    },
                    label: Text(
                      AppLocalizations.of(context).remove_this_apartment,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}

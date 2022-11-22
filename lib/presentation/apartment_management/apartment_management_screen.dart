import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_cubit.dart';
import 'package:priorli/presentation/apartment_management/apartment_management_state.dart';
import 'package:priorli/presentation/home/main_screen.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import '../housing_company/housing_company_screen.dart';
import '../send_invitation/invite_tenant_screen.dart';
import '../shared/setting_button.dart';

const housingCompanyManageScreenPath = 'manage';

class ApartmentManagementScreen extends StatefulWidget {
  const ApartmentManagementScreen({super.key});

  @override
  State<ApartmentManagementScreen> createState() =>
      _ApartmentManagementScreenState();
}

class _ApartmentManagementScreenState extends State<ApartmentManagementScreen> {
  final ApartmentManagementCubit cubit =
      serviceLocator<ApartmentManagementCubit>();
  final _apartmentName = TextEditingController();
  final _houseCode = TextEditingController();

  @override
  void dispose() {
    _apartmentName.dispose();
    _houseCode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  _getInitialData() async {
    final housingCompanyId =
        Uri.parse(GoRouter.of(context).location).pathSegments[1];
    final apartmentId =
        Uri.parse(GoRouter.of(context).location).pathSegments[3];
    final state = await cubit.init(housingCompanyId, apartmentId);
    _apartmentName.text = state.apartment?.building ?? '';
    _houseCode.text = state.apartment?.houseCode ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApartmentManagementCubit>(
      create: (_) => cubit,
      child: BlocBuilder<ApartmentManagementCubit, ApartmentManagementState>(
          builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                  onPressed: state.apartment != state.pendingApartment
                      ? () {
                          cubit.saveNewApartmentInfo();
                        }
                      : null,
                  child: const Text('Save'),
                )
              ],
              title: const Text('Manage'),
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
                          hintText: 'Building name',
                          autofocus: false,
                          onChanged: (value) =>
                              cubit.updateAparmentBuildingName(value),
                          keyboardType: TextInputType.name,
                        ),
                        CustomFormField(
                          hintText: 'House code',
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
                    onPressed: () async {
                      final result = await cubit.deleteThisApartment();
                      if (result) {
                        if (!context.mounted) return;
                        context.go(
                            '$housingCompanyScreenPath/${state.apartment?.housingCompanyId}');
                      }
                    },
                    label: Text(
                      'Delete this apartment',
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/go_router_navigation.dart';
import 'package:priorli/presentation/join_apartment/join_apartment_cubit.dart';
import 'package:priorli/presentation/join_apartment/join_apartment_state.dart';
import 'package:priorli/presentation/shared/custom_form_field.dart';
import 'package:priorli/service_locator.dart';

import '../apartments/apartment_screen.dart';
import '../housing_company/housing_company_screen.dart';

const joinApartmentPath = '/join_apartment';

class JoinApartmentScreen extends StatefulWidget {
  const JoinApartmentScreen({super.key, this.code});
  final String? code;

  @override
  State<JoinApartmentScreen> createState() => _JoinApartmentScreenState();
}

class _JoinApartmentScreenState extends State<JoinApartmentScreen> {
  late final JoinApartmentCubit _cubit;
  @override
  void initState() {
    _cubit = serviceLocator<JoinApartmentCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JoinApartmentCubit>(
        create: (_) => _cubit..init(code: widget.code),
        child: BlocConsumer<JoinApartmentCubit, JoinApartmentState>(
            listener: (context, state) {
              if (state.addedToApartment?.id.isNotEmpty == true &&
                  state.addedToApartment?.housingCompanyId.isNotEmpty == true) {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(mainPathName));
                GoRouter.of(context).push(
                    '/$housingCompanyScreenPath/${state.addedToApartment?.housingCompanyId}');
                GoRouter.of(context).push(
                    '/$housingCompanyScreenPath/${state.addedToApartment?.housingCompanyId}/$apartmentScreenPath/${state.addedToApartment?.id}');
              }
            },
            builder: (context, state) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Join an apartment with invitation code'),
                  ),
                  body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomFormField(
                          hintText: 'Code',
                          icon: const Icon(
                            Icons.abc,
                          ),
                          helperText: 'Invitation code from company',
                          initialValue: '${state.code}',
                          onChanged: (code) => _cubit.onTypingCode(code),
                        ),
                        OutlinedButton(
                            onPressed: state.code?.isNotEmpty == true
                                ? () => _cubit.joinWithCode()
                                : null,
                            child: const Text('Confirm'))
                      ]),
                )));
  }
}

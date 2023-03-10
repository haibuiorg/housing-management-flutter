import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/utils/color_extension.dart';
import 'package:priorli/presentation/file_selector/file_selector.dart';
import 'package:priorli/presentation/housing_company_ui/housing_company_ui_screen_cubit.dart';
import 'package:priorli/presentation/housing_company_ui/housing_company_ui_screen_state.dart';
import 'package:priorli/service_locator.dart';

import '../../core/utils/constants.dart';
import '../shared/full_width_title.dart';

const housingCompanyUiScreenPath = 'appearance';

class HousingCompanyUiScreen extends StatefulWidget {
  const HousingCompanyUiScreen({super.key, required this.housingCompanyId});
  final String housingCompanyId;

  @override
  State<HousingCompanyUiScreen> createState() => _HousingCompanyUiScreenState();
}

class _HousingCompanyUiScreenState extends State<HousingCompanyUiScreen> {
  late final HousingCompanyUiScreenCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = serviceLocator<HousingCompanyUiScreenCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInitialData();
    });
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  _getInitialData() async {
    await _cubit.init(widget.housingCompanyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
      ),
      body: BlocProvider<HousingCompanyUiScreenCubit>(
        create: (_) => _cubit,
        child: BlocBuilder<HousingCompanyUiScreenCubit,
            HousingCompanyUiScreenState>(builder: (context, state) {
          return SingleChildScrollView(
            child: Column(children: [
              const FullWidthTitle(
                title: 'Company logo',
              ),
              InkWell(
                onTap: () => showDialog(
                    context: context,
                    builder: (builder) => Dialog(
                          child: FileSelector(
                              isSingleFile: true,
                              isImageOnly: true,
                              onCompleteUploaded: (onCompleteUploaded) {
                                if (onCompleteUploaded.isNotEmpty == true) {
                                  _cubit
                                      .uploadNewLogo(onCompleteUploaded[0])
                                      .then((value) =>
                                          Navigator.pop(builder, true));
                                }
                              }),
                        )),
                child: state.company?.logoUrl.isNotEmpty == true
                    ? CircleAvatar(
                        radius: 56,
                        backgroundImage:
                            NetworkImage(state.company?.logoUrl ?? ''),
                      )
                    : CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        radius: 56,
                        child: Text(
                          state.company?.name.characters.first.toUpperCase() ??
                              'H',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
              ),
              const FullWidthTitle(
                title: 'Cover photo',
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => showDialog(
                    context: context,
                    builder: (builder) => Dialog(
                      child: FileSelector(
                          isSingleFile: true,
                          isImageOnly: true,
                          onCompleteUploaded: (onCompleteUploaded) {
                            if (onCompleteUploaded.isNotEmpty == true) {
                              _cubit.uploadNewCover(onCompleteUploaded[0]).then(
                                  (value) => Navigator.pop(builder, true));
                            }
                          }),
                    ),
                  ),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: 200,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    imageUrl: state.company?.coverImageUrl ?? '',
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: state.company?.ui?.seedColor != null
                              ? HexColor.fromHex(
                                  state.company?.ui?.seedColor ?? appSeedColor)
                              : Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
              const FullWidthTitle(
                title: 'Company primary color',
              ),
              InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (builder) => Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Dialog(
                      child: MaterialPicker(
                          pickerColor: Theme.of(context).colorScheme.primary,
                          onColorChanged: (color) {
                            _cubit
                                .updateCompanyColor(colorToHex(color,
                                    includeHashSign: true, enableAlpha: false))
                                .then((value) => Navigator.pop(builder, true));
                          }),
                    ),
                  ),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: state.company?.ui?.seedColor != null
                          ? HexColor.fromHex(
                              state.company?.ui?.seedColor ?? appSeedColor)
                          : Theme.of(context).colorScheme.primary),
                ),
              ),
              SizedBox.fromSize(
                size: const Size.fromHeight(100),
              )
            ]),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/apartment/entities/apartment.dart';
import 'package:priorli/core/water_usage/entities/water_consumption.dart';
import 'package:priorli/presentation/add_apartment/add_apartment_screen.dart';
import 'package:priorli/presentation/housing_company/housing_company_cubit.dart';
import 'package:priorli/presentation/housing_company/housing_company_state.dart';
import 'package:priorli/service_locator.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../announcement/announcement_screen.dart';
import '../apartments/apartment_screen.dart';
import '../housing_company_management/housing_company_management_screen.dart';
import '../shared/announcement_item.dart';
import '../water_consumption_management/water_consumption_management_screen.dart';

const housingCompanyScreenPath = '/housing_company';

class HousingCompanyScreen extends StatefulWidget {
  const HousingCompanyScreen({super.key, required this.housingCompanyId});
  final String housingCompanyId;

  @override
  State<HousingCompanyScreen> createState() => _HousingCompanyScreenState();
}

class _HousingCompanyScreenState extends State<HousingCompanyScreen> {
  final cubit = serviceLocator<HousingCompanyCubit>();

  @override
  Widget build(BuildContext context) {
    cubit.init(widget.housingCompanyId);
    return BlocProvider<HousingCompanyCubit>(
      create: (_) => cubit,
      child: BlocBuilder<HousingCompanyCubit, HousingCompanyState>(
          builder: (context, state) {
        if (state.housingCompany?.ui != null) {
          BlocProvider.of<SettingCubit>(context)
              .updateUIFromCompany(state.housingCompany?.ui);
        }
        return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                  onPressed: () {
                    context.push(
                        '${GoRouter.of(context).location}/$manageScreenPath');
                  },
                  child: const Text('Manage'),
                )
              ],
              title: Text(state.housingCompany?.name ?? 'Housing company'),
            ),
            body: CustomScrollView(clipBehavior: Clip.none, slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Announcement',
                          style: Theme.of(context).textTheme.displaySmall),
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final announcement = state.announcementList?[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: announcement != null
                        ? AnnouncementItem(
                            announcement: announcement,
                          )
                        : const SizedBox.shrink(),
                  );
                },
                childCount: (state.announcementList?.length ?? 0),
              )),
              SliverToBoxAdapter(
                  child: TextButton(
                      onPressed: () {
                        context.push(
                            '${GoRouter.of(context).location}/$announcementPath');
                      },
                      child: const Text('More'))),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text('Water consumption',
                              style: Theme.of(context).textTheme.displaySmall),
                        ),
                        OutlinedButton.icon(
                            icon: const Icon(Icons.water_damage_outlined),
                            onPressed: () {
                              context.push(
                                  '${GoRouter.of(context).location}/$waterConsumptionManagementScreenPath');
                            },
                            label: const Text('Detail'))
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
                  child: SfCartesianChart(
                      // Initialize category axis
                      primaryXAxis: CategoryAxis(),
                      enableAxisAnimation: true,
                      series: <CartesianSeries<WaterConsumption, int>>[
                        ColumnSeries<WaterConsumption, int>(
                            // Bind data source
                            animationDuration: 1500,
                            color: Theme.of(context).colorScheme.primary,
                            dataSource: state.yearlyWaterConsumption ?? [],
                            xValueMapper:
                                (WaterConsumption waterConsumption, _) =>
                                    waterConsumption.period,
                            yValueMapper:
                                (WaterConsumption waterConsumption, _) =>
                                    waterConsumption.totalReading),
                        SplineSeries<WaterConsumption, int>(
                            animationDuration: 1500,
                            dataSource: state.yearlyWaterConsumption ?? [],
                            xValueMapper:
                                (WaterConsumption waterConsumption, _) =>
                                    waterConsumption.period,
                            yValueMapper:
                                (WaterConsumption waterConsumption, _) =>
                                    waterConsumption.pricePerCube),
                        SplineSeries<WaterConsumption, int>(
                            animationDuration: 1500,
                            dataSource: state.yearlyWaterConsumption ?? [],
                            xValueMapper:
                                (WaterConsumption waterConsumption, _) =>
                                    waterConsumption.period,
                            yValueMapper:
                                (WaterConsumption waterConsumption, _) =>
                                    waterConsumption.basicFee),
                      ]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Apartments',
                          style: Theme.of(context).textTheme.displaySmall),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.push(
                              '${GoRouter.of(context).location}/$addApartmentPath');
                        },
                        icon: const Icon(Icons.add_home),
                        label: const Text('Add'),
                      )
                    ],
                  ),
                ),
              ),
              SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return InkWell(
                        onTap: () {
                          context.push(
                              '${GoRouter.of(context).location}/$apartmentScreenPath/${state.apartmentList?[index].id}');
                        },
                        child: ApartmentTile(
                          apartment: state.apartmentList![index],
                        ));
                  }, childCount: state.apartmentList?.length ?? 0)),
            ]));
      }),
    );
  }
}

class ApartmentTile extends StatefulWidget {
  const ApartmentTile({super.key, required this.apartment});
  final Apartment apartment;
  @override
  State<ApartmentTile> createState() => _ApartmentTileState();
}

class _ApartmentTileState extends State<ApartmentTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(child: Text(widget.apartment.building)),
    );
  }
}

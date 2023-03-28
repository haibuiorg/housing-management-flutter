import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/notification_center/notification_center_cubit.dart';
import 'package:priorli/presentation/notification_center/notification_center_state.dart';
import 'package:priorli/service_locator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widget/notification_center_item.dart';

const notificationCenterPath = '/notification_center';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  late final ScrollController _controller;
  final cubit = serviceLocator<NotificationCenterCubit>();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()
      ..addListener(() {
        if (_controller.position.extentAfter < (cubit.state.total ?? 10)) {
          cubit.loadMore();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationCenterCubit>(
      create: (_) => cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).notification_center),
        ),
        body: BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
            builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => cubit.init(),
            child: ListView.builder(
                controller: _controller,
                itemCount: (state.notificationMessageList?.length ?? 0),
                itemBuilder: (context, index) {
                  final notificationMessage =
                      state.notificationMessageList?[index];
                  return notificationMessage == null
                      ? const SizedBox.shrink()
                      : NotificationCenterItem(
                          onPress: () {
                            GoRouter.of(context)
                                .push(notificationMessage.appRouteLocation);
                          },
                          notificationMessage: notificationMessage,
                        );
                }),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/notification_center/notification_center_cubit.dart';
import 'package:priorli/presentation/notification_center/notification_center_state.dart';
import 'package:priorli/service_locator.dart';

import '../../core/utils/time_utils.dart';

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
        print(_controller.position.extentAfter);
        if (_controller.position.extentAfter < 300) {
          cubit.loadMore();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationCenterCubit>(
      create: (_) => cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification center'),
        ),
        body: BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
            builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => cubit.init(),
            child: ListView.builder(
                controller: _controller,
                itemCount: (state.notificationMessageList?.length ?? 0) + 1,
                itemBuilder: (context, index) {
                  return index < (state.notificationMessageList?.length ?? 0)
                      ? Text(getFormattedDateTime(
                          state.notificationMessageList?[index].createdOn ?? 0))
                      : OutlinedButton(
                          onPressed: () => cubit.loadMore(),
                          child: const Text('Load More'));
                }),
          );
        }),
      ),
    );
  }
}

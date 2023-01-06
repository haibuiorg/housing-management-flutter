import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/setting_cubit.dart';
import 'package:priorli/setting_state.dart';

class TapCard extends StatelessWidget {
  const TapCard(
      {super.key,
      required this.child,
      this.onTap,
      this.backgroundColor,
      this.height,
      this.width});
  final Widget child;
  final Color? backgroundColor;
  final Function()? onTap;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              border: const BorderDirectional(),
              color: backgroundColor ??
                  Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: child,
        );
      }),
    );
  }
}

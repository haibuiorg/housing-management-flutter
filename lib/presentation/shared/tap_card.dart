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
      this.height});
  final Widget child;
  final Color? backgroundColor;
  final Function()? onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
        return Container(
          height: height,
          decoration: BoxDecoration(
              border: const BorderDirectional(),
              backgroundBlendMode: state.brightness == Brightness.light
                  ? BlendMode.modulate
                  : BlendMode.plus,
              color: backgroundColor ??
                  Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          child: child,
        );
      }),
    );
  }
}

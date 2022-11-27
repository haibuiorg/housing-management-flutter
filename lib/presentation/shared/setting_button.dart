import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget? label;
  final Widget? icon;
  const SettingButton({super.key, this.onPressed, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface))),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            label ?? const SizedBox.shrink(),
            icon ?? const Icon(Icons.chevron_right_outlined)
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FullWidthTitle extends StatelessWidget {
  const FullWidthTitle({super.key, this.title, this.action});
  final String? title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            child: Text(
              title ?? '',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
          ),
          action ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}

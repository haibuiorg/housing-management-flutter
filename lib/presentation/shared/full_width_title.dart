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
            fit: BoxFit.fitWidth,
            child: Text(
              title ?? '',
              textScaleFactor: 1,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          action ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}

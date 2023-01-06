import 'package:flutter/material.dart';

class FullWidthPairText extends StatelessWidget {
  const FullWidthPairText({super.key, required this.label, this.content});

  final String label;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(content ?? '')],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FullWidthPairText extends StatelessWidget {
  const FullWidthPairText(
      {super.key,
      required this.label,
      this.content,
      this.isBoldContent = false});

  final String label;
  final String? content;
  final bool isBoldContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Text(content ?? '',
              style: isBoldContent
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : null)
        ],
      ),
    );
  }
}

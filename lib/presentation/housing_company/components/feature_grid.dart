import 'package:flutter/cupertino.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid(
      {super.key,
      required this.title,
      required this.content,
      required this.footer});
  final String title;
  final Widget? content;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}

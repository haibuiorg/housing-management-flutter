import 'package:flutter/material.dart';

import '../../../core/apartment/entities/apartment.dart';

class ApartmentTile extends StatefulWidget {
  const ApartmentTile({super.key, required this.apartment});
  final Apartment apartment;
  @override
  State<ApartmentTile> createState() => _ApartmentTileState();
}

class _ApartmentTileState extends State<ApartmentTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Center(child: Text(widget.apartment.building)),
    );
  }
}

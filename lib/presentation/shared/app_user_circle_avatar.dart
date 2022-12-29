import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:priorli/core/user/entities/user.dart';

class AppUserCircleAvatar extends StatelessWidget {
  const AppUserCircleAvatar({super.key, this.user, this.radius = 56});
  final User? user;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: user?.avatarUrl?.isNotEmpty == true
          ? CachedNetworkImageProvider(
              user?.avatarUrl ?? '',
            )
          : null,
      child: user?.avatarUrl?.isNotEmpty == true
          ? null
          : Text(
              (user?.firstName.isNotEmpty == true
                      ? user?.firstName.characters.first.toUpperCase() ?? ''
                      : '') +
                  (user?.lastName.isNotEmpty == true
                      ? user?.lastName.characters.first.toUpperCase() ?? ''
                      : ''),
              style: Theme.of(context).textTheme.displaySmall,
            ),
    );
  }
}

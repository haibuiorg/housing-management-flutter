import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/core/utils/color_extension.dart';
import 'package:priorli/core/utils/constants.dart';
import 'package:priorli/presentation/admin/admin_screen.dart';
import 'package:priorli/presentation/home/home_screen.dart';
import 'package:priorli/presentation/login/login_screen.dart';
import 'package:priorli/presentation/main/main_cubit.dart';
import 'package:priorli/presentation/main/main_state.dart';
import 'package:priorli/presentation/profile/profile_screen.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/service_locator.dart';
import 'package:priorli/user_cubit.dart';
import 'package:priorli/user_state.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../account/account_screen.dart';
import '../conversation_list/conversation_list_screen.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const mainPath = '/';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.child});
  final Widget child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final MainCubit _cubit;
  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
    _cubit = serviceLocator<MainCubit>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final currentPath = GoRouter.of(context).location.replaceAll('/', '');
      int selectedIndex = currentPath.contains(homePath)
          ? 0
          : GoRouter.of(context)
                  .location
                  .contains(conversationListPath..replaceAll('/', ''))
              ? 1
              : GoRouter.of(context)
                      .location
                      .contains(profilePath..replaceAll('/', ''))
                  ? 2
                  : GoRouter.of(context)
                          .location
                          .contains(adminScreenPath.replaceAll('/', ''))
                      ? 3
                      : 0;
      await _cubit.init(selectedIndex).then((value) {
        if (!value) {
          GoRouter.of(context).go(loginPath);
        }
      });
    });
  }

  _checkNotificationPermission() {
    if (kIsWeb) {
      return;
    }
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (builder) => AlertDialog(
                  content: Text(AppLocalizations.of(context)!
                      .notification_permission_message),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications();
                          Navigator.pop(builder, true);
                        },
                        child: Text(AppLocalizations.of(context)!.thatsok)),
                  ],
                ));
      }
    });
  }

  void _onItemTapped(int index, BuildContext context) {
    BlocProvider.of<MainCubit>(context).changeTab(index);
    switch (index) {
      case 0:
        {
          GoRouter.of(context).go(homePath);
          break;
        }
      case 1:
        {
          GoRouter.of(context).go(conversationListPath);
          break;
        }
      case 2:
        {
          GoRouter.of(context).go(profilePath);
          break;
        }
      case 3:
        {
          GoRouter.of(context).go(adminScreenPath);
          break;
        }
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainCubit>(
      create: (context) => _cubit,
      child: BlocBuilder<MainCubit, MainState>(builder: (context, state) {
        return state.isInitializing
            ? const Center(
                child: AppLottieAnimation(loadingResource: 'apartment'),
              )
            : DefaultUI(
                initialIndex: state.selectedTabIndex ?? 0,
                onItemTapped: _onItemTapped,
                isAdmin: state.isAdmin ?? false,
                child: widget.child,
              );
      }),
    );
  }
}

class DefaultUI extends StatefulWidget {
  const DefaultUI({
    super.key,
    required this.child,
    required this.initialIndex,
    required this.onItemTapped,
    required this.isAdmin,
  });
  final Widget child;
  final int initialIndex;
  final Function(int index, BuildContext context) onItemTapped;
  final bool isAdmin;

  @override
  State<DefaultUI> createState() => _DefaultUIState();
}

class _DefaultUIState extends State<DefaultUI> {
  late final SidebarXController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        SidebarXController(selectedIndex: widget.initialIndex, extended: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      return Scaffold(
        bottomNavigationBar: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? SnakeNavigationBar.color(
                behaviour: SnakeBarBehaviour.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: HexColor.fromHex(appPrimaryContainerColorDark),
                currentIndex: state.selectedTabIndex ?? 0,
                padding: const EdgeInsets.all(16),
                snakeViewColor: HexColor.fromHex(appBackgroundColorDark),
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(context).colorScheme.primary,
                items: [
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.home, size: 30)),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.feed, size: 30)),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.settings, size: 30)),
                  if (widget.isAdmin)
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.admin_panel_settings, size: 30)),
                ],
                onTap: (index) => widget.onItemTapped(index, context),
              )
            : null,
        body: ResponsiveWrapper.of(context).isLargerThan(MOBILE)
            ? Row(
                children: [
                  SidebarX(
                      theme: SidebarXTheme(
                        selectedTextStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.primary),
                        selectedIconTheme: IconThemeData(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        selectedItemDecoration: BoxDecoration(
                          color: HexColor.fromHex(appPrimaryContainerColorDark),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      extendedTheme: const SidebarXTheme(
                          width: 300,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          selectedItemTextPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemTextPadding:
                              EdgeInsets.symmetric(horizontal: 16)),
                      controller: _controller,
                      headerBuilder: (context, extended) {
                        return Container(
                          decoration: BoxDecoration(
                            color:
                                HexColor.fromHex(appPrimaryContainerColorDark),
                            borderRadius: BorderRadius.circular(150),
                          ),
                          margin: EdgeInsets.all(extended ? 32 : 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: InkWell(
                              onTap: () =>
                                  GoRouter.of(context).push(accountPath),
                              child: BlocBuilder<UserCubit, UserState>(
                                  builder: (context, userState) {
                                return userState.user?.avatarUrl?.isNotEmpty ==
                                        true
                                    ? Image.network(
                                        userState.user?.avatarUrl ?? '',
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        'assets/images/avatar.png',
                                        fit: BoxFit.contain,
                                      );
                              }),
                            ),
                          ),
                        );
                      },
                      items: [
                        SidebarXItem(
                          icon: (Icons.home),
                          label:
                              (AppLocalizations.of(context)!.housing_companies),
                          onTap: () => widget.onItemTapped(0, context),
                        ),
                        SidebarXItem(
                            icon: (Icons.feed),
                            label: (AppLocalizations.of(context)!.messages),
                            onTap: () => widget.onItemTapped(1, context)),
                        SidebarXItem(
                            icon: (Icons.settings),
                            label: (AppLocalizations.of(context)!.settings),
                            onTap: () => widget.onItemTapped(2, context)),
                        if (widget.isAdmin)
                          SidebarXItem(
                              icon: (Icons.admin_panel_settings),
                              label:
                                  (AppLocalizations.of(context)!.admin_panel),
                              onTap: () => widget.onItemTapped(3, context)),
                      ]),
                  Expanded(child: widget.child)
                ],
              )
            : widget.child,
      );
    });
  }
}

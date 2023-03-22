import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/admin/admin_screen.dart';
import 'package:priorli/presentation/home/home_screen.dart';
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
      await _cubit.init(selectedIndex);
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
                  content: const Text(
                      'Do you want to receive notification when there are new important announcements or when something require your action?'),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications();
                          Navigator.pop(builder, true);
                        },
                        child: const Text('That\'s ok'))
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
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                currentIndex: state.selectedTabIndex ?? 0,
                padding: const EdgeInsets.all(16),
                snakeViewColor: Theme.of(context).colorScheme.background,
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
                      ),
                      extendedTheme: const SidebarXTheme(width: 200),
                      controller: _controller,
                      headerBuilder: (context, extended) {
                        return Container(
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () => GoRouter.of(context).push(accountPath),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: BlocBuilder<UserCubit, UserState>(
                                  builder: (context, userState) {
                                return userState.user?.avatarUrl?.isNotEmpty ==
                                        true
                                    ? Image.network(
                                        userState.user?.avatarUrl ?? '',
                                      )
                                    : Image.asset('assets/images/avatar.png');
                              }),
                            ),
                          ),
                        );
                      },
                      items: [
                        SidebarXItem(
                          icon: (Icons.home),
                          label: ('Housing companies'),
                          onTap: () => widget.onItemTapped(0, context),
                        ),
                        SidebarXItem(
                            icon: (Icons.feed),
                            label: ('Messages'),
                            onTap: () => widget.onItemTapped(1, context)),
                        SidebarXItem(
                            icon: (Icons.settings),
                            label: ('Settings'),
                            onTap: () => widget.onItemTapped(2, context)),
                        if (widget.isAdmin)
                          SidebarXItem(
                              icon: (Icons.admin_panel_settings),
                              label: ('Admin'),
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

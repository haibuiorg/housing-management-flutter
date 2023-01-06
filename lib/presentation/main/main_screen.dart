import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
import 'package:collapsible_sidebar/collapsible_sidebar.dart';

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
      await _cubit.init();
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
            : state.isAdmin == true
                ? AdminUI(child: widget.child)
                : DefaultUI(
                    child: widget.child,
                  );
      }),
    );
  }
}

class AdminUI extends StatelessWidget {
  const AdminUI({
    super.key,
    required this.child,
  });
  final Widget child;

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;

    if (location == (adminScreenPath)) {
      return 0;
    }

    if (location == (conversationListPath)) {
      return 2;
    }
    if (location == (profilePath)) {
      return 3;
    }
    return 1;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(adminScreenPath);
        break;
      case 1:
        GoRouter.of(context).go(homePath);
        break;
      case 2:
        GoRouter.of(context).go(conversationListPath);
        break;
      case 3:
        GoRouter.of(context).go(profilePath);
        break;
    }
  }

  List<CollapsibleItem> _generateItems(BuildContext context) {
    return [
      CollapsibleItem(
        icon: (Icons.manage_accounts),
        text: ('Admin'),
        onPressed: () => _onItemTapped(0, context),
        isSelected: _calculateSelectedIndex(context) == 0,
      ),
      CollapsibleItem(
        icon: (Icons.home),
        text: ('Housing companies'),
        onPressed: () => _onItemTapped(1, context),
        isSelected: _calculateSelectedIndex(context) == 1,
      ),
      CollapsibleItem(
          icon: (Icons.feed),
          text: ('Conversations'),
          isSelected: _calculateSelectedIndex(context) == 2,
          onPressed: () => _onItemTapped(2, context)),
      CollapsibleItem(
          icon: (Icons.settings),
          text: ('Settings'),
          isSelected: _calculateSelectedIndex(context) == 3,
          onPressed: () => _onItemTapped(3, context)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      return Scaffold(
        extendBody: false,
        bottomNavigationBar: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? SnakeNavigationBar.color(
                behaviour: SnakeBarBehaviour.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                currentIndex: _calculateSelectedIndex(context),
                padding: const EdgeInsets.all(16),
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.admin_panel_settings, size: 30)),
                  BottomNavigationBarItem(icon: Icon(Icons.home, size: 30)),
                  BottomNavigationBarItem(icon: Icon(Icons.feed, size: 30)),
                  BottomNavigationBarItem(icon: Icon(Icons.settings, size: 30)),
                ],
                onTap: (index) => _onItemTapped(index, context),
              )
            : null,
        body: Row(
          children: [
            ResponsiveVisibility(
              visible: false,
              visibleWhen: const [
                Condition.largerThan(name: MOBILE, landscapeValue: TABLET),
              ],
              child: CollapsibleSidebar(
                  titleStyle: Theme.of(context).textTheme.bodyMedium,
                  toggleTitle: '',
                  onTitleTap: () {
                    GoRouter.of(context).push(accountPath);
                  },
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  isCollapsed: ResponsiveValue(
                        context,
                        defaultValue: true,
                        valueWhen: const [
                          Condition.smallerThan(
                            name: TABLET,
                            value: true,
                          ),
                          Condition.largerThan(
                            name: TABLET,
                            value: false,
                          )
                        ],
                      ).value ??
                      false,
                  unselectedTextColor: Theme.of(context).colorScheme.secondary,
                  selectedTextColor: Theme.of(context).colorScheme.primary,
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  selectedIconColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  unselectedIconColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  selectedIconBox:
                      Theme.of(context).colorScheme.secondaryContainer,
                  title:
                      '${state.user?.firstName ?? ''} ${state.user?.lastName ?? ''}',
                  avatarImg: NetworkImage(
                    state.user?.avatarUrl ?? '',
                  ),
                  items: _generateItems(context),
                  sidebarBoxShadow: const [],
                  body: const SizedBox.shrink()),
            ),
            Expanded(child: child)
          ],
        ),
      );
    });
  }
}

class DefaultUI extends StatelessWidget {
  const DefaultUI({
    super.key,
    required this.child,
  });
  final Widget child;

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).location;

    if (location == (homePath)) {
      return 0;
    }

    if (location == (profilePath)) {
      return 2;
    }
    return 1;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(homePath);
        break;
      case 1:
        GoRouter.of(context).go(conversationListPath);
        break;
      case 2:
        GoRouter.of(context).go(profilePath);
        break;
    }
  }

  List<CollapsibleItem> _generateItems(BuildContext context) {
    return [
      CollapsibleItem(
        icon: (Icons.home),
        text: ('Housing companies'),
        onPressed: () => _onItemTapped(0, context),
        isSelected: _calculateSelectedIndex(context) == 0,
      ),
      CollapsibleItem(
          icon: (Icons.feed),
          text: ('Conversations'),
          isSelected: _calculateSelectedIndex(context) == 1,
          onPressed: () => _onItemTapped(1, context)),
      CollapsibleItem(
          icon: (Icons.settings),
          text: ('Settings'),
          isSelected: _calculateSelectedIndex(context) == 2,
          onPressed: () => _onItemTapped(2, context)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      return Scaffold(
        bottomNavigationBar: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? SnakeNavigationBar.color(
                behaviour: SnakeBarBehaviour.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),

                //color: Theme.of(context).colorScheme.primaryContainer,
                currentIndex: _calculateSelectedIndex(context),
                padding: const EdgeInsets.all(16),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home, size: 30)),
                  BottomNavigationBarItem(icon: Icon(Icons.feed, size: 30)),
                  BottomNavigationBarItem(icon: Icon(Icons.settings, size: 30)),
                ],
                onTap: (index) => _onItemTapped(index, context),
              )
            : null,
        body: ResponsiveWrapper.of(context).isLargerThan(PHONE)
            ? Row(
                children: [
                  CollapsibleSidebar(
                      titleStyle: Theme.of(context).textTheme.bodyMedium,
                      toggleTitle: '',
                      onTitleTap: () {
                        GoRouter.of(context).push(accountPath);
                      },
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      isCollapsed: ResponsiveValue(
                            context,
                            defaultValue: true,
                            valueWhen: const [
                              Condition.smallerThan(
                                name: TABLET,
                                value: true,
                              ),
                              Condition.largerThan(
                                name: TABLET,
                                value: false,
                              )
                            ],
                          ).value ??
                          false,
                      unselectedTextColor:
                          Theme.of(context).colorScheme.secondary,
                      selectedTextColor: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      selectedIconColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      unselectedIconColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      selectedIconBox:
                          Theme.of(context).colorScheme.secondaryContainer,
                      title:
                          '${state.user?.firstName}… ${state.user?.lastName}',
                      avatarImg: NetworkImage(
                        state.user?.avatarUrl ?? '',
                      ),
                      items: _generateItems(context),
                      sidebarBoxShadow: const [],
                      body: const SizedBox.shrink()),
                  Expanded(child: child)
                ],
              )
            : child,
      );
    });
  }
}

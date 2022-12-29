import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:priorli/presentation/admin/admin_screen.dart';
import 'package:priorli/presentation/home/home_screen.dart';
import 'package:priorli/presentation/main/main_cubit.dart';
import 'package:priorli/presentation/main/main_state.dart';
import 'package:priorli/presentation/profile/profile_screen.dart';
import 'package:priorli/presentation/shared/app_lottie_animation.dart';
import 'package:priorli/service_locator.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../conversation_list/conversation_list_screen.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';

const mainPath = '/main';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
            builder: (context) => AlertDialog(
                  content: const Text(
                      'Do you want to receive notification when there are new important announcements or when something require your action?'),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications();
                          Navigator.pop(context, true);
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
                ? const AdminUI()
                : const DefaultUI();
      }),
    );
  }
}

class AdminUI extends StatefulWidget {
  const AdminUI({
    super.key,
  });

  @override
  State<AdminUI> createState() => _AdminUIState();
}

class _AdminUIState extends State<AdminUI> {
  int _selectedIndex = 0;
  late List<Widget> _adminScreens;
  late List<CollapsibleItem> _items;

  _changePage(int position) {
    setState(() {
      _selectedIndex = position;
    });
  }

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    _adminScreens = _generateScreens;
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> get _generateScreens {
    return [
      const AdminScreen(),
      const HomeScreen(),
      const ConversationListScreen(),
      const SettingScreen(),
    ];
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        icon: (Icons.manage_accounts),
        text: ('Admin'),
        onPressed: () => _changePage(0),
        isSelected: _selectedIndex == 0,
      ),
      CollapsibleItem(
        icon: (Icons.home),
        text: ('Housing companies'),
        onPressed: () => _changePage(1),
        isSelected: _selectedIndex == 1,
      ),
      CollapsibleItem(
          icon: (Icons.feed),
          text: ('Conversations'),
          isSelected: _selectedIndex == 2,
          onPressed: () => _changePage(2)),
      CollapsibleItem(
          icon: (Icons.settings),
          text: ('Profile'),
          isSelected: _selectedIndex == 3,
          onPressed: () => _changePage(3)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      return Scaffold(
        bottomNavigationBar: ResponsiveVisibility(
          visible: false,
          visibleWhen: const [
            Condition.equals(name: MOBILE),
          ],
          child: CurvedNavigationBar(
            backgroundColor: Theme.of(context).canvasColor,
            color: Theme.of(context).colorScheme.primaryContainer,
            index: _selectedIndex,
            items: const [
              Icon(Icons.manage_accounts, size: 30),
              Icon(Icons.home, size: 30),
              Icon(Icons.feed, size: 30),
              Icon(Icons.settings, size: 30),
            ],
            onTap: _changePage,
          ),
        ),
        body: Row(
          children: [
            ResponsiveVisibility(
              visible: false,
              visibleWhen: const [
                Condition.largerThan(name: MOBILE),
              ],
              child: CollapsibleSidebar(
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
                  title: '${state.user?.firstName}… ${state.user?.lastName}',
                  avatarImg:
                      CachedNetworkImageProvider(state.user?.avatarUrl ?? ''),
                  items: _items,
                  sidebarBoxShadow: const [],
                  body: const SizedBox.shrink()),
            ),
            Expanded(child: _adminScreens[_selectedIndex])
          ],
        ),
      );
    });
  }
}

class DefaultUI extends StatefulWidget {
  const DefaultUI({
    super.key,
  });

  @override
  State<DefaultUI> createState() => _DefaultUIState();
}

class _DefaultUIState extends State<DefaultUI> {
  int _selectedIndex = 0;
  late List<Widget> _adminScreens;
  late List<CollapsibleItem> _items;

  _changePage(int position) {
    setState(() {
      _selectedIndex = position;
    });
  }

  @override
  void initState() {
    super.initState();
    _items = _generateItems;
    _adminScreens = _generateScreens;
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> get _generateScreens {
    return [
      const HomeScreen(),
      const ConversationListScreen(),
      const SettingScreen(),
    ];
  }

  List<CollapsibleItem> get _generateItems {
    return [
      CollapsibleItem(
        icon: (Icons.home),
        text: ('Housing companies'),
        onPressed: () => _changePage(0),
        isSelected: _selectedIndex == 0,
      ),
      CollapsibleItem(
          icon: (Icons.feed),
          text: ('Conversations'),
          isSelected: _selectedIndex == 1,
          onPressed: () => _changePage(1)),
      CollapsibleItem(
          icon: (Icons.settings),
          text: ('Profile'),
          isSelected: _selectedIndex == 2,
          onPressed: () => _changePage(2)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      return Scaffold(
        bottomNavigationBar: ResponsiveVisibility(
          visible: false,
          visibleWhen: const [
            Condition.equals(name: MOBILE),
          ],
          child: CurvedNavigationBar(
            backgroundColor: Theme.of(context).canvasColor,
            color: Theme.of(context).colorScheme.primaryContainer,
            index: _selectedIndex,
            items: const [
              Icon(Icons.home, size: 30),
              Icon(Icons.feed, size: 30),
              Icon(Icons.settings, size: 30),
            ],
            onTap: _changePage,
          ),
        ),
        body: Row(
          children: [
            ResponsiveVisibility(
              visible: false,
              visibleWhen: const [
                Condition.largerThan(name: MOBILE),
              ],
              child: CollapsibleSidebar(
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
                  title: '${state.user?.firstName}… ${state.user?.lastName}',
                  avatarImg:
                      CachedNetworkImageProvider(state.user?.avatarUrl ?? ''),
                  items: _items,
                  sidebarBoxShadow: const [],
                  body: const SizedBox.shrink()),
            ),
            Expanded(child: _adminScreens[_selectedIndex])
          ],
        ),
      );
    });
  }
}

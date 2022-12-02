import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:priorli/presentation/home/home_screen.dart';
import 'package:priorli/presentation/profile/profile_screen.dart';
import '../conversation_list/conversation_list_screen.dart';
import '../notification_center/notification_center_screen.dart';

const mainPath = '/';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  _checkNotificationPermission() {
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

  final List<Widget> _screens = [
    const HomeScreen(),
    const ConversationListScreen(),
    const SettingScreen(),
  ];

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,

              // called when one tab is selected
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              // bottom tab items
              items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.feed), label: 'Conversations'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_2), label: 'Profile')
                ])
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 640)
            NavigationRail(
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedIndex: _selectedIndex,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.feed), label: Text('Conversation s')),
                NavigationRailDestination(
                    icon: Icon(Icons.settings), label: Text('Profile')),
              ],

              labelType: NavigationRailLabelType.all,

              unselectedLabelTextStyle: const TextStyle(),
              // Called when one tab is selected
            ),
          Expanded(child: _screens[_selectedIndex])
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

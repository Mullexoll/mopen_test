import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'favorites.screen.dart';
import 'home.screen.dart';
import 'search.screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  TabBarScreenState createState() => TabBarScreenState();
}

class TabBarScreenState extends State<TabBarScreen> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _selectTab(int index) {
    if (_currentIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<bool> onWillPop() async {
    _selectTab(0);
    final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_currentIndex].currentState!.maybePop();
    if (isFirstRouteInCurrentTab) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        bool value = await onWillPop();
        if (value) {
          navigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            _buildOffstageNavigator(0, const HomeScreen()),
            _buildOffstageNavigator(
              1,
              SearchScreen(
                onWillPop: onWillPop,
              ),
            ),
            _buildOffstageNavigator(
              2,
              FavoritesScreen(
                onWillPop: onWillPop,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 0,
          onTap: _selectTab,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home_disable_icon.svg',
                width: 20,
                height: 20,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/home_active_icon.svg',
                width: 20,
                height: 20,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/search_disable_icon.svg',
                width: 20,
                height: 20,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/search_active_icon.svg',
                width: 20,
                height: 20,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/bookmark_disable_icon.svg',
                width: 20,
                height: 20,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/bookmark_active_icon.svg',
                width: 20,
                height: 20,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index, Widget child) {
    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => child,
          );
        },
      ),
    );
  }
}

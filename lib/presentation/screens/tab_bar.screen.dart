import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mopen_test/constants/connection_status_consts.dart';

import 'favorites.screen.dart';
import 'home.screen.dart';
import 'search.screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  TabBarScreenState createState() => TabBarScreenState();
}

class TabBarScreenState extends State<TabBarScreen> {
  String connectionStatus = ConnectionStatusConsts.unknownConnection;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _tabs = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
    );
  }
}

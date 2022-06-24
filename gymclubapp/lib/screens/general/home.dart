// ignore: import_of_legacy_library_into_null_safe
// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/general/profile.dart';
import 'package:gymclubapp/screens/general/workoutdashboard.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:gymclubapp/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State Class
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List<Widget> _listPages = [
    FeedPage(),
    WorkoutDashboardScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // [Widget] Curved Bottom Navigation Bar
    final bottomCurvedNavBar = CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: hexStringToColor("000000"),
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.person_outline, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        });

    // Main Body
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: feedAppBar,
      body: _listPages[_page],
      bottomNavigationBar: bottomCurvedNavBar,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:job_tracker_app/screens/tracker/tracker_screen.dart';
import 'job_search/job_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    JobSearchScreen(),
    TrackerScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FlutterRemix.search_line),
            activeIcon: Icon(FlutterRemix.search_fill),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(FlutterRemix.briefcase_4_line),
            activeIcon: Icon(FlutterRemix.briefcase_4_fill),
            label: 'Tracker',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

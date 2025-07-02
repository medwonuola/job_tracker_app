import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:job_tracker_app/features/job_search/job_search_screen.dart';
import 'package:job_tracker_app/features/tracker/tracker_screen.dart';

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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 2.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FlutterRemix.search_line, size: 28),
              activeIcon: Icon(FlutterRemix.search_fill, size: 28),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(FlutterRemix.briefcase_line, size: 28),
              activeIcon: Icon(FlutterRemix.briefcase_fill, size: 28),
              label: 'Tracker',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

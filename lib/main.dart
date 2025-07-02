import 'package:flutter/material.dart';
import 'package:job_tracker_app/providers/application_tracker_provider.dart';
import 'package:job_tracker_app/providers/job_search_provider.dart';
import 'package:job_tracker_app/screens/home_screen.dart';
import 'package:job_tracker_app/theme/d3x_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const JobTrackerApp());
}

class JobTrackerApp extends StatelessWidget {
  const JobTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobSearchProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationTrackerProvider()),
      ],
      child: MaterialApp(
        title: 'D3X Job Tracker',
        theme: D3XTheme.darkTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

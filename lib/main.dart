import 'package:flutter/material.dart';
import 'package:job_tracker_app/data/providers/application_tracker_provider.dart';
import 'package:job_tracker_app/data/providers/job_search_provider.dart';
import 'package:job_tracker_app/features/home/home_screen.dart';
import 'package:job_tracker_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ContextApp());
}

class ContextApp extends StatelessWidget {
  const ContextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobSearchProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationTrackerProvider()),
      ],
      child: MaterialApp(
        title: 'Context Job Tracker',
        theme: ContextTheme.lightTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:job_tracker_app/data/providers/application_tracker_provider.dart';
import 'package:job_tracker_app/data/providers/job_search_provider.dart';
import 'package:job_tracker_app/features/home/home_screen.dart';
import 'package:job_tracker_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final applicationTrackerProvider = ApplicationTrackerProvider();
  await applicationTrackerProvider.loadTrackedJobs();

  runApp(ContextApp(applicationTrackerProvider: applicationTrackerProvider));
}

class ContextApp extends StatelessWidget {
  final ApplicationTrackerProvider applicationTrackerProvider;

  const ContextApp({
    super.key,
    required this.applicationTrackerProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobSearchProvider()),
        ChangeNotifierProvider.value(value: applicationTrackerProvider),
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

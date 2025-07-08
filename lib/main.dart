import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:job_tracker_app/data/providers/application_tracker_provider.dart';
import 'package:job_tracker_app/data/providers/job_search_provider.dart';
import 'package:job_tracker_app/data/providers/stats_provider.dart';
import 'package:job_tracker_app/features/home/home_screen.dart';
import 'package:job_tracker_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (e) {
    debugPrint(
        'Warning: .env file not found. Please create .env file with RAPIDAPI_KEY.',);
  }

  final applicationTrackerProvider = ApplicationTrackerProvider();
  await applicationTrackerProvider.loadTrackedJobs();

  runApp(JobsTrackerApp(applicationTrackerProvider: applicationTrackerProvider));
}

class JobsTrackerApp extends StatelessWidget {
  final ApplicationTrackerProvider applicationTrackerProvider;

  const JobsTrackerApp({
    super.key,
    required this.applicationTrackerProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobSearchProvider()),
        ChangeNotifierProvider.value(value: applicationTrackerProvider),
        ChangeNotifierProxyProvider<ApplicationTrackerProvider, StatsProvider>(
          create: (context) => StatsProvider(
            Provider.of<ApplicationTrackerProvider>(context, listen: false),
          ),
          update: (context, tracker, previousStats) => StatsProvider(tracker),
        ),
      ],
      child: MaterialApp(
        title: 'Jobs Tracker',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

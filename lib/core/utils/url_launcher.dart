import 'package:url_launcher/url_launcher.dart';

class AppUrlLauncher {
  static Future<void> launch(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $urlString');
    }
  }
}

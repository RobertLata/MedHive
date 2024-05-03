import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<void> launchURLBrowser(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
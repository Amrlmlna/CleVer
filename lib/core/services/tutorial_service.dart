import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static final TutorialService _instance = TutorialService._internal();
  factory TutorialService() => _instance;
  TutorialService._internal();

  static const String _kJobOcrKey = 'has_shown_job_ocr_tutorial';
  static const String _kNavTutorialKey = 'has_shown_nav_tutorial';

  Future<bool> hasShownJobOcr() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kJobOcrKey) ?? false;
  }

  Future<void> markJobOcrAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kJobOcrKey, true);
  }

  Future<bool> hasShownNavTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kNavTutorialKey) ?? false;
  }

  Future<void> markNavTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNavTutorialKey, true);
  }
}

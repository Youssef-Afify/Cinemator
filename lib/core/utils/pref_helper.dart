import 'package:shared_preferences/shared_preferences.dart';

class SessionData {
  final String name;
  final String email;

  const SessionData({required this.name, required this.email});
}

class PrefHelper {
  static const String _session = 'Session';
  static const String _name = 'Username';
  static const String _email = 'Email';
  static const String _suggestPage = 'SuggestPage';

  static Future<void> saveSession(String name, String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_session, true);
    await prefs.setString(_name, name);
    await prefs.setString(_email, email);
  }

  static Future<SessionData?> getSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool session = prefs.getBool(_session) ?? false;
    if (!session) {
      return null;
    }
    final String name = prefs.getString(_name) ?? 'N/A';
    final String email = prefs.getString(_email) ?? 'N/A';
    return SessionData(name: name, email: email);
  }

  static Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_session);
    await prefs.remove(_name);
    await prefs.remove(_email);
  }

  // Deliberately not cleared by clearSession() — this isn't tied to any
  // particular signed-in user, it's just a cached "which top-rated page
  // are we currently suggesting from" pointer for the Suggestions slider.
  // It should survive logout/login so suggestions stay stable across
  // sessions, not just within one.
  static Future<void> setSuggestPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_suggestPage, page);
  }

  static Future<int?> getSuggestPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_suggestPage);
  }
}
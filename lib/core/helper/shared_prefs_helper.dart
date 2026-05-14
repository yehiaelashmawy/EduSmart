import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get hasSeenOnboarding =>
      _prefs.getBool('hasSeenOnboarding') ?? false;
  static Future<void> setHasSeenOnboarding(bool value) async =>
      await _prefs.setBool('hasSeenOnboarding', value);

  static bool get isAuthenticated => _prefs.getBool('isAuthenticated') ?? false;
  static Future<void> setIsAuthenticated(bool value) async =>
      await _prefs.setBool('isAuthenticated', value);

  static String? get userRole => _prefs.getString('userRole');
  static Future<void> setUserRole(String role) async =>
      await _prefs.setString('userRole', role);

  static String? get token => _prefs.getString('token');
  static Future<void> setToken(String tokenValue) async =>
      await _prefs.setString('token', tokenValue);

  static String? get fullName => _prefs.getString('fullName');
  static Future<void> setFullName(String name) async =>
      await _prefs.setString('fullName', name);

  static String? get userId => _prefs.getString('userId');
  static Future<void> setUserId(String id) async =>
      await _prefs.setString('userId', id);

  static String? get teacherOid => _prefs.getString('teacherOid');
  static Future<void> setTeacherOid(String id) async =>
      await _prefs.setString('teacherOid', id);

  static bool get isDarkMode => _prefs.getBool('isDarkMode') ?? false;
  static Future<void> setIsDarkMode(bool value) async =>
      await _prefs.setBool('isDarkMode', value);

  static bool getRememberMe(String role) =>
      _prefs.getBool('${role}_rememberMe') ?? false;
  static Future<void> setRememberMe(String role, bool value) async =>
      await _prefs.setBool('${role}_rememberMe', value);

  static String? getSavedEmail(String role) =>
      _prefs.getString('${role}_savedEmail');
  static Future<void> setSavedEmail(String role, String email) async =>
      await _prefs.setString('${role}_savedEmail', email);

  static String? getSavedPassword(String role) =>
      _prefs.getString('${role}_savedPassword');
  static Future<void> setSavedPassword(String role, String password) async =>
      await _prefs.setString('${role}_savedPassword', password);

  static Future<void> clearSavedCredentials(String role) async {
    await _prefs.remove('${role}_rememberMe');
    await _prefs.remove('${role}_savedEmail');
    await _prefs.remove('${role}_savedPassword');
  }

  static Future<void> clearAuth() async {
    await _prefs.remove('isAuthenticated');
    await _prefs.remove('userRole');
    await _prefs.remove('token');
    await _prefs.remove('fullName');
    await _prefs.remove('userId');
    await _prefs.remove('teacherOid');
  }
}

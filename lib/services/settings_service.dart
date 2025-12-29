import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Push notifications
  Future<bool> getPushNotifications() async {
    return (await prefs).getBool('push_notifications') ?? true;
  }

  Future<void> setPushNotifications(bool value) async {
    await (await prefs).setBool('push_notifications', value);
  }

  // Email updates
  Future<bool> getEmailUpdates() async {
    return (await prefs).getBool('email_updates') ?? false;
  }

  Future<void> setEmailUpdates(bool value) async {
    await (await prefs).setBool('email_updates', value);
  }



// ... any other setting you want to add
}
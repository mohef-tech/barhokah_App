import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/masjid_config.dart';

class ConfigService {
  static Future<void> save(MasjidConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.prefsKey, jsonEncode(config.toMap()));
  }

  static Future<MasjidConfig?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConfig.prefsKey);
    if (raw == null) return null;
    return MasjidConfig.fromMap(jsonDecode(raw));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.prefsKey);
  }
}
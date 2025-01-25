import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _languageKey = "language_code";
  static const String _figureKey = "selected_figure";
  static const String _imageFigureKey = "selected_image";
  static const String _selectedFigureId = "selected_id";

  static Future<void> saveLanguageCode(String languageCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  static Future<String?> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  static Future<void> saveSelectedImage(String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageFigureKey, imagePath);
  }

  static Future<String?> getSelectedImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imageFigureKey);
  }

  static Future<void> saveSelectedFigureId(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedFigureId, id);
  }

  static Future<String?> getSelectedFigureId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedFigureId);
  }

  static Future<void> saveSelectedFigure(String figureName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_figureKey, figureName);
  }

  static Future<String?> getSelectedFigure() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_figureKey);
  }

  static Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageKey);
    await prefs.remove(_figureKey);
  }
}

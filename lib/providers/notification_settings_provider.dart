import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsProvider with ChangeNotifier {
  bool _learningReminders = true; // Default to true

  bool get learningReminders => _learningReminders;

  NotificationSettingsProvider() {
    _loadSettings();
  }

  void setLearningReminders(bool value) {
    _learningReminders = value;
    _saveSettings();
    notifyListeners();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Load the setting, defaulting to true if it's not found
    _learningReminders = prefs.getBool('learningReminders') ?? true;
    notifyListeners();
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('learningReminders', _learningReminders);
  }
}
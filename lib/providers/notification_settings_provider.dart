import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

enum ProviderState { Loading, Loaded, Error }

class NotificationSettingsProvider with ChangeNotifier {
  ProviderState _state = ProviderState.Loading;
  ProviderState get state => _state;

  bool _learningReminders = true;
  bool get learningReminders => _learningReminders;

  NotificationSettingsProvider();

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _learningReminders = prefs.getBool('learningReminders') ?? true;
      _state = ProviderState.Loaded;
    } catch (e) {
      _state = ProviderState.Error;
    }
  }

  void setLearningReminders(bool value) {
    _learningReminders = value;
    _saveSettings();
    notifyListeners();
    ApiService().updateNotificationPreference(value);
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('learningReminders', _learningReminders);
  }
}
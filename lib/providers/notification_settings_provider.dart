import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/api_service.dart';

enum ProviderState { Loading, Loaded, Error }

class NotificationSettingsProvider with ChangeNotifier {
  ProviderState _state = ProviderState.Loading;
  ProviderState get state => _state;

  bool _learningRemindersEnabled = true;
  bool _announcementsEnabled = true;

  bool get learningRemindersEnabled => _learningRemindersEnabled;
  bool get announcementsEnabled => _announcementsEnabled;

  final String _announcementsTopic = 'announcements';

  NotificationSettingsProvider();

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Load both settings, defaulting to true if not found
      _learningRemindersEnabled = prefs.getBool('learningRemindersEnabled') ?? true;
      _announcementsEnabled = prefs.getBool('announcementsEnabled') ?? true;
      
      // Ensure the topic subscription matches the saved setting on startup
      await _syncAnnouncementsSubscription();
      
      _state = ProviderState.Loaded;
    } catch (e) {
      _state = ProviderState.Error;
    }
  }

  Future<void> setLearningReminders(bool value) async {
    _learningRemindersEnabled = value;
    notifyListeners();
    await _saveSettings();
    
    ApiService().updateNotificationPreference(value);
  }

  Future<void> setAnnouncements(bool value) async {
    _announcementsEnabled = value;
    notifyListeners();
    await _saveSettings();
    
    // This subscribes/unsubscribes directly from the app
    await _syncAnnouncementsSubscription();
  }

  Future<void> _syncAnnouncementsSubscription() async {
    try {
      if (_announcementsEnabled) {
        await FirebaseMessaging.instance.subscribeToTopic(_announcementsTopic);
        print('Subscribed to $_announcementsTopic');
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic(_announcementsTopic);
        print('Unsubscribed from $_announcementsTopic');
      }
    } catch (e) {
      print('Failed to sync topic subscription: $e');
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('learningRemindersEnabled', _learningRemindersEnabled);
    await prefs.setBool('announcementsEnabled', _announcementsEnabled);
  }
}
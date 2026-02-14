import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/notification_service.dart';
import '../services/settings_service.dart';

class SettingsController extends GetxController {
  SettingsController({
    required SettingsService settingsService,
    required NotificationService notificationService,
    ThemeMode? initialThemeMode,
  })  : _settingsService = settingsService,
        _notificationService = notificationService,
        _hasInitialTheme = initialThemeMode != null {
    if (initialThemeMode != null) {
      themeMode.value = initialThemeMode;
    }
  }

  final SettingsService _settingsService;
  final NotificationService _notificationService;
  final bool _hasInitialTheme;

  final themeMode = ThemeMode.system.obs;
  final notificationsEnabled = true.obs;

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_hasInitialTheme) {
        themeMode.value = await _settingsService.loadThemeMode();
        Get.changeThemeMode(themeMode.value);
      }
      notificationsEnabled.value = await _notificationService.areNotificationsEnabled();
    });
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _settingsService.saveThemeMode(mode);
    Get.changeThemeMode(mode);
  }

  Future<void> refreshNotificationStatus() async {
    notificationsEnabled.value = await _notificationService.areNotificationsEnabled();
  }

  Future<void> requestNotificationPermission() async {
    await _notificationService.requestPermission();
    await refreshNotificationStatus();
  }
}

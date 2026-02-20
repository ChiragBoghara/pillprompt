import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'medicine_controller.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';

class SettingsController extends GetxController {
  SettingsController({
    required SettingsService settingsService,
    required NotificationService notificationService,
    ThemeMode? initialThemeMode,
    Locale? initialLocale,
  }) : _settingsService = settingsService,
       _notificationService = notificationService,
       _hasInitialTheme = initialThemeMode != null,
       _hasInitialLocale = initialLocale != null {
    if (initialThemeMode != null) {
      themeMode.value = initialThemeMode;
    }
    if (initialLocale != null) {
      locale.value = initialLocale;
    }
  }

  final SettingsService _settingsService;
  final NotificationService _notificationService;
  final bool _hasInitialTheme;
  final bool _hasInitialLocale;

  final themeMode = ThemeMode.system.obs;
  final locale = const Locale('en').obs;
  final notificationsEnabled = true.obs;

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_hasInitialTheme) {
        themeMode.value = await _settingsService.loadThemeMode();
        Get.changeThemeMode(themeMode.value);
      }
      if (!_hasInitialLocale) {
        locale.value = Locale(await _settingsService.loadLocaleCode());
        Get.updateLocale(locale.value);
      }
      notificationsEnabled.value = await _notificationService
          .areNotificationsEnabled();
    });
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    await _settingsService.saveThemeMode(mode);
    Get.changeThemeMode(mode);
  }

  Future<void> setLocale(Locale nextLocale) async {
    if (locale.value.languageCode == nextLocale.languageCode) {
      return;
    }

    locale.value = nextLocale;
    Get.updateLocale(nextLocale);
    await _settingsService.saveLocaleCode(nextLocale.languageCode);

    if (Get.isRegistered<MedicineController>()) {
      await Get.find<MedicineController>().rescheduleActiveMedicines();
    }
  }

  Future<void> refreshNotificationStatus() async {
    notificationsEnabled.value = await _notificationService
        .areNotificationsEnabled();
  }

  Future<void> requestNotificationPermission() async {
    await _notificationService.requestPermission();
    await refreshNotificationStatus();
  }
}

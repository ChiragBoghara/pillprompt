import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/medicine_controller.dart';
import '../controllers/log_controller.dart';
import '../controllers/settings_controller.dart';
import '../data/repositories/medicine_repository.dart';
import '../data/repositories/medicine_log_repository.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';
import 'app.dart';

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  bool _ready = false;
  String? _error;
  late final Future<void> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _initialize();
  }

  Future<void> _initialize() async {
    try {
      final notificationService = NotificationService.instance;
      await notificationService.init();

      final settingsService = SettingsService();
      final initialTheme = await settingsService.loadThemeMode();

      Get.put(
        SettingsController(
          settingsService: settingsService,
          notificationService: notificationService,
          initialThemeMode: initialTheme,
        ),
      );
      Get.put(
        MedicineController(
          repository: MedicineRepository(),
          notificationService: notificationService,
        ),
      );
      Get.put(LogController(repository: MedicineLogRepository()));
    } catch (error) {
      _error = error.toString();
    } finally {
      if (mounted) {
        setState(() => _ready = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (!_ready) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        if (_error != null) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Startup error: $_error',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }

        return const PillPromptApp();
      },
    );
  }
}

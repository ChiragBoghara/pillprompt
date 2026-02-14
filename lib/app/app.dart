import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'theme/app_theme.dart';
import '../controllers/settings_controller.dart';

class PillPromptApp extends StatelessWidget {
  const PillPromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
      builder: (SettingsController controller) {
        return GetMaterialApp(
          title: 'PillPrompt',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: controller.themeMode.value,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}

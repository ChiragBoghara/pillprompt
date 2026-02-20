import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'theme/app_theme.dart';
import '../controllers/settings_controller.dart';
import '../l10n/app_localizations.dart';
import '../l10n/l10n.dart';

class PillPromptApp extends StatelessWidget {
  const PillPromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
      builder: (SettingsController controller) {
        return GetMaterialApp(
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: controller.themeMode.value,
          locale: controller.locale.value,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        );
      },
    );
  }
}

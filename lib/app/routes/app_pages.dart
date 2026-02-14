import 'package:get/get.dart';

import '../../features/history/history_page.dart';
import '../../features/home/home_page.dart';
import '../../features/medicine/medicine_form_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/splash/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(name: AppRoutes.medicineForm, page: () => const MedicineFormPage()),
    GetPage(name: AppRoutes.history, page: () => const HistoryPage()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
  ];
}

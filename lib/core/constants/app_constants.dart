class AppConstants {
  static const String appName = 'PillPrompt';
  static const String dbName = 'pillprompt.db';

  static const String tableMedicines = 'medicines';
  static const String tableLogs = 'medicine_logs';

  static const String notificationChannelId = 'pillprompt_reminders';
  static const String notificationChannelName = 'Medication Reminders';
  static const String notificationChannelDesc = 'Medication reminder alerts';

  static const int snoozeMinutesDefault = 15;

  static const String actionTaken = 'action_taken';
  static const String actionSnooze = 'action_snooze';

  static const String appLogo = 'assets/images/app-logo.png';
}

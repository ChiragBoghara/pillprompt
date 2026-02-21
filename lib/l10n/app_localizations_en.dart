// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PillPrompt';

  @override
  String get splashTagline => 'Gentle reminders, on your time.';

  @override
  String startupError(Object message) {
    return 'Startup error: $message';
  }

  @override
  String get todayTitle => 'Today';

  @override
  String get todaysMedicines => 'Today\'s Medicines';

  @override
  String get historyTooltip => 'History';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get addMedicine => 'Add Medicine';

  @override
  String get noMedicinesYet => 'No medicines yet';

  @override
  String get addFirstMedicine => 'Add your first medicine to get started.';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get paused => 'Paused';

  @override
  String get beforeFood => 'Before Food';

  @override
  String get afterFood => 'After Food';

  @override
  String get active => 'Active';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteMedicineTitle => 'Delete medicine?';

  @override
  String get deleteMedicineContent =>
      'This will remove the medicine and its reminders.';

  @override
  String get cancel => 'Cancel';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get themeLabel => 'Theme';

  @override
  String get languageLabel => 'Language';

  @override
  String get englishLabel => 'English';

  @override
  String get germanLabel => 'German';

  @override
  String get alertsSection => 'Alerts';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get permissionEnabled => 'Permission: Enabled';

  @override
  String get permissionDisabled => 'Permission: Disabled';

  @override
  String get manage => 'Manage';

  @override
  String get supportSection => 'Support';

  @override
  String get aboutPillPrompt => 'About PillPrompt';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String version(Object value) {
    return 'Version $value';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get medicationHistory => 'Medication history';

  @override
  String get filterByMedicineOrDateRange => 'Filter by medicine or date range.';

  @override
  String get medicineLabel => 'Medicine';

  @override
  String get allMedicines => 'All medicines';

  @override
  String get dateRangeLabel => 'Date range';

  @override
  String get noHistoryFound => 'No history found for the selected filters.';

  @override
  String get allDates => 'All dates';

  @override
  String get medicineFormEditTitle => 'Edit Medicine';

  @override
  String get medicineFormAddTitle => 'Add Medicine';

  @override
  String get updateDetails => 'Update details';

  @override
  String get medicineDetails => 'Medicine details';

  @override
  String get medicineNameLabel => 'Medicine name';

  @override
  String get medicineNameHint => 'e.g., Metformin';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get dosageLabel => 'Dosage';

  @override
  String get dosageHint => 'e.g., 500 mg';

  @override
  String get dosageRequired => 'Dosage is required';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get frequencyDaily => 'Daily';

  @override
  String get frequencySpecificDays => 'Specific Days';

  @override
  String get daysLabel => 'Days';

  @override
  String get timesLabel => 'Times';

  @override
  String get addTime => 'Add time';

  @override
  String get startDateLabel => 'Start date';

  @override
  String get endDateOptionalLabel => 'End date (optional)';

  @override
  String get selectDate => 'Select date';

  @override
  String get pauseHint =>
      'Turn off to pause reminders without deleting this medicine';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get saveMedicine => 'Save Medicine';

  @override
  String get selectAtLeastOneDay => 'Select at least one day';

  @override
  String get selectAtLeastOneTime => 'Select at least one time';

  @override
  String get startDateRequired => 'Start date is required';

  @override
  String get endDateAfterStart => 'End date must be after the start date';

  @override
  String get statusTaken => 'Taken';

  @override
  String get statusMissed => 'Missed';

  @override
  String get statusSnoozed => 'Snoozed';

  @override
  String get snoozeLabel => 'Snooze';

  @override
  String get snooze15 => '15 min';

  @override
  String get snooze30 => '30 min';

  @override
  String get snooze60 => '1 hour';

  @override
  String nextReminder(Object time) {
    return 'Next reminder: $time';
  }

  @override
  String timeToTake(Object dosage) {
    return 'Time to take $dosage';
  }

  @override
  String get notificationActionTaken => 'Taken';

  @override
  String get notificationActionSnooze => 'Snooze';

  @override
  String get notificationChannelName => 'Medication Reminders';

  @override
  String get notificationChannelDescription => 'Medication reminder alerts';

  @override
  String get fallbackMedicineName => 'Medicine';

  @override
  String dosesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doses',
      one: '1 dose',
    );
    return '$_temp0';
  }

  @override
  String get snackMedicineAdded => 'Medicine added';

  @override
  String get snackMedicineUpdated => 'Medicine updated';

  @override
  String get snackMedicineDeleted => 'Medicine deleted';

  @override
  String get snackMarkedTaken => 'Marked as taken';

  @override
  String get snackMarkedMissed => 'Marked as missed';

  @override
  String snackSnoozed(int minutes) {
    return 'Snoozed for $minutes min';
  }

  @override
  String get aboutTitle => 'About PillPrompt';

  @override
  String get aboutDescription =>
      'PillPrompt helps you stay on track with your medications through gentle, timely reminders. Never miss a dose again.';

  @override
  String get aboutDeveloperLabel => 'Developer';

  @override
  String get aboutDeveloperName => 'PillPrompt Team';

  @override
  String get aboutContactUs => 'Contact Us';

  @override
  String get aboutContactEmail => 'support@pillprompt.app';

  @override
  String get aboutRateApp => 'Rate on Play Store';

  @override
  String get aboutRateAppSubtitle => 'Love PillPrompt? Leave us a review!';

  @override
  String get aboutShareApp => 'Share App';

  @override
  String get aboutShareAppSubtitle => 'Tell your friends about PillPrompt';

  @override
  String get aboutShareMessage =>
      'Check out PillPrompt — a simple medication reminder app!\nhttps://play.google.com/store/apps/details?id=com.pillprompt.app';

  @override
  String get aboutTermsOfService => 'Terms of Service';

  @override
  String get aboutOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get generalSection => 'General';

  @override
  String get linksSection => 'Links';

  @override
  String get legalSection => 'Legal';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'PillPrompt'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Gentle reminders, on your time.'**
  String get splashTagline;

  /// No description provided for @startupError.
  ///
  /// In en, this message translates to:
  /// **'Startup error: {message}'**
  String startupError(Object message);

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;

  /// No description provided for @todaysMedicines.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Medicines'**
  String get todaysMedicines;

  /// No description provided for @historyTooltip.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicine;

  /// No description provided for @noMedicinesYet.
  ///
  /// In en, this message translates to:
  /// **'No medicines yet'**
  String get noMedicinesYet;

  /// No description provided for @addFirstMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add your first medicine to get started.'**
  String get addFirstMedicine;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @beforeFood.
  ///
  /// In en, this message translates to:
  /// **'Before Food'**
  String get beforeFood;

  /// No description provided for @afterFood.
  ///
  /// In en, this message translates to:
  /// **'After Food'**
  String get afterFood;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteMedicineTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete medicine?'**
  String get deleteMedicineTitle;

  /// No description provided for @deleteMedicineContent.
  ///
  /// In en, this message translates to:
  /// **'This will remove the medicine and its reminders.'**
  String get deleteMedicineContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;

  /// No description provided for @germanLabel.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get germanLabel;

  /// No description provided for @alertsSection.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alertsSection;

  /// No description provided for @notificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsLabel;

  /// No description provided for @permissionEnabled.
  ///
  /// In en, this message translates to:
  /// **'Permission: Enabled'**
  String get permissionEnabled;

  /// No description provided for @permissionDisabled.
  ///
  /// In en, this message translates to:
  /// **'Permission: Disabled'**
  String get permissionDisabled;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportSection;

  /// No description provided for @aboutPillPrompt.
  ///
  /// In en, this message translates to:
  /// **'About PillPrompt'**
  String get aboutPillPrompt;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {value}'**
  String version(Object value);

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @medicationHistory.
  ///
  /// In en, this message translates to:
  /// **'Medication history'**
  String get medicationHistory;

  /// No description provided for @filterByMedicineOrDateRange.
  ///
  /// In en, this message translates to:
  /// **'Filter by medicine or date range.'**
  String get filterByMedicineOrDateRange;

  /// No description provided for @medicineLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicineLabel;

  /// No description provided for @allMedicines.
  ///
  /// In en, this message translates to:
  /// **'All medicines'**
  String get allMedicines;

  /// No description provided for @dateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRangeLabel;

  /// No description provided for @noHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No history found for the selected filters.'**
  String get noHistoryFound;

  /// No description provided for @allDates.
  ///
  /// In en, this message translates to:
  /// **'All dates'**
  String get allDates;

  /// No description provided for @medicineFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Medicine'**
  String get medicineFormEditTitle;

  /// No description provided for @medicineFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get medicineFormAddTitle;

  /// No description provided for @updateDetails.
  ///
  /// In en, this message translates to:
  /// **'Update details'**
  String get updateDetails;

  /// No description provided for @medicineDetails.
  ///
  /// In en, this message translates to:
  /// **'Medicine details'**
  String get medicineDetails;

  /// No description provided for @medicineNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine name'**
  String get medicineNameLabel;

  /// No description provided for @medicineNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Metformin'**
  String get medicineNameHint;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @dosageLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosageLabel;

  /// No description provided for @dosageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 500 mg'**
  String get dosageHint;

  /// No description provided for @dosageRequired.
  ///
  /// In en, this message translates to:
  /// **'Dosage is required'**
  String get dosageRequired;

  /// No description provided for @frequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequencyLabel;

  /// No description provided for @frequencyDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get frequencyDaily;

  /// No description provided for @frequencySpecificDays.
  ///
  /// In en, this message translates to:
  /// **'Specific Days'**
  String get frequencySpecificDays;

  /// No description provided for @daysLabel.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get daysLabel;

  /// No description provided for @timesLabel.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get timesLabel;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDateLabel;

  /// No description provided for @endDateOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'End date (optional)'**
  String get endDateOptionalLabel;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @pauseHint.
  ///
  /// In en, this message translates to:
  /// **'Turn off to pause reminders without deleting this medicine'**
  String get pauseHint;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saveMedicine.
  ///
  /// In en, this message translates to:
  /// **'Save Medicine'**
  String get saveMedicine;

  /// No description provided for @selectAtLeastOneDay.
  ///
  /// In en, this message translates to:
  /// **'Select at least one day'**
  String get selectAtLeastOneDay;

  /// No description provided for @selectAtLeastOneTime.
  ///
  /// In en, this message translates to:
  /// **'Select at least one time'**
  String get selectAtLeastOneTime;

  /// No description provided for @startDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Start date is required'**
  String get startDateRequired;

  /// No description provided for @endDateAfterStart.
  ///
  /// In en, this message translates to:
  /// **'End date must be after the start date'**
  String get endDateAfterStart;

  /// No description provided for @statusTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get statusTaken;

  /// No description provided for @statusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get statusMissed;

  /// No description provided for @statusSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed'**
  String get statusSnoozed;

  /// No description provided for @snoozeLabel.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snoozeLabel;

  /// No description provided for @snooze15.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get snooze15;

  /// No description provided for @snooze30.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get snooze30;

  /// No description provided for @snooze60.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get snooze60;

  /// No description provided for @nextReminder.
  ///
  /// In en, this message translates to:
  /// **'Next reminder: {time}'**
  String nextReminder(Object time);

  /// No description provided for @timeToTake.
  ///
  /// In en, this message translates to:
  /// **'Time to take {dosage}'**
  String timeToTake(Object dosage);

  /// No description provided for @notificationActionTaken.
  ///
  /// In en, this message translates to:
  /// **'Taken'**
  String get notificationActionTaken;

  /// No description provided for @notificationActionSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get notificationActionSnooze;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Medication Reminders'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Medication reminder alerts'**
  String get notificationChannelDescription;

  /// No description provided for @fallbackMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get fallbackMedicineName;

  /// No description provided for @dosesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 dose} other{{count} doses}}'**
  String dosesCount(int count);

  /// No description provided for @snackMedicineAdded.
  ///
  /// In en, this message translates to:
  /// **'Medicine added'**
  String get snackMedicineAdded;

  /// No description provided for @snackMedicineUpdated.
  ///
  /// In en, this message translates to:
  /// **'Medicine updated'**
  String get snackMedicineUpdated;

  /// No description provided for @snackMedicineDeleted.
  ///
  /// In en, this message translates to:
  /// **'Medicine deleted'**
  String get snackMedicineDeleted;

  /// No description provided for @snackMarkedTaken.
  ///
  /// In en, this message translates to:
  /// **'Marked as taken'**
  String get snackMarkedTaken;

  /// No description provided for @snackMarkedMissed.
  ///
  /// In en, this message translates to:
  /// **'Marked as missed'**
  String get snackMarkedMissed;

  /// No description provided for @snackSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed for {minutes} min'**
  String snackSnoozed(int minutes);

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About PillPrompt'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'PillPrompt helps you stay on track with your medications through gentle, timely reminders. Never miss a dose again.'**
  String get aboutDescription;

  /// No description provided for @aboutDeveloperLabel.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloperLabel;

  /// No description provided for @aboutDeveloperName.
  ///
  /// In en, this message translates to:
  /// **'PillPrompt Team'**
  String get aboutDeveloperName;

  /// No description provided for @aboutContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get aboutContactUs;

  /// No description provided for @aboutContactEmail.
  ///
  /// In en, this message translates to:
  /// **'support@pillprompt.app'**
  String get aboutContactEmail;

  /// No description provided for @aboutRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate on Play Store'**
  String get aboutRateApp;

  /// No description provided for @aboutRateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Love PillPrompt? Leave us a review!'**
  String get aboutRateAppSubtitle;

  /// No description provided for @aboutShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get aboutShareApp;

  /// No description provided for @aboutShareAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell your friends about PillPrompt'**
  String get aboutShareAppSubtitle;

  /// No description provided for @aboutShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out PillPrompt — a simple medication reminder app!\nhttps://play.google.com/store/apps/details?id=com.pillprompt.app'**
  String get aboutShareMessage;

  /// No description provided for @aboutTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get aboutTermsOfService;

  /// No description provided for @aboutOpenSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get aboutOpenSourceLicenses;

  /// No description provided for @generalSection.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalSection;

  /// No description provided for @linksSection.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get linksSection;

  /// No description provided for @legalSection.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legalSection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

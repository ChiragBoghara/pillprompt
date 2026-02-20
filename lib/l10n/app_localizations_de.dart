// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'PillPrompt';

  @override
  String get splashTagline => 'Sanfte Erinnerungen, zu deiner Zeit.';

  @override
  String startupError(Object message) {
    return 'Startfehler: $message';
  }

  @override
  String get todayTitle => 'Heute';

  @override
  String get todaysMedicines => 'Heutige Medikamente';

  @override
  String get historyTooltip => 'Verlauf';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get addMedicine => 'Medikament hinzufügen';

  @override
  String get noMedicinesYet => 'Noch keine Medikamente';

  @override
  String get addFirstMedicine =>
      'Füge dein erstes Medikament hinzu, um zu starten.';

  @override
  String get upcoming => 'Bevorstehend';

  @override
  String get paused => 'Pausiert';

  @override
  String get beforeFood => 'Vor dem Essen';

  @override
  String get afterFood => 'Nach dem Essen';

  @override
  String get active => 'Aktiv';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteMedicineTitle => 'Medikament löschen?';

  @override
  String get deleteMedicineContent =>
      'Dadurch werden das Medikament und seine Erinnerungen entfernt.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get preferencesSection => 'Präferenzen';

  @override
  String get themeLabel => 'Design';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get englishLabel => 'Englisch';

  @override
  String get germanLabel => 'Deutsch';

  @override
  String get alertsSection => 'Hinweise';

  @override
  String get notificationsLabel => 'Benachrichtigungen';

  @override
  String get permissionEnabled => 'Berechtigung: Aktiviert';

  @override
  String get permissionDisabled => 'Berechtigung: Deaktiviert';

  @override
  String get manage => 'Verwalten';

  @override
  String get supportSection => 'Support';

  @override
  String get aboutPillPrompt => 'Über PillPrompt';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String version(Object value) {
    return 'Version $value';
  }

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get medicationHistory => 'Medikamentenverlauf';

  @override
  String get filterByMedicineOrDateRange =>
      'Nach Medikament oder Datumsbereich filtern.';

  @override
  String get medicineLabel => 'Medikament';

  @override
  String get allMedicines => 'Alle Medikamente';

  @override
  String get dateRangeLabel => 'Datumsbereich';

  @override
  String get noHistoryFound =>
      'Kein Verlauf für die ausgewählten Filter gefunden.';

  @override
  String get allDates => 'Alle Daten';

  @override
  String get medicineFormEditTitle => 'Medikament bearbeiten';

  @override
  String get medicineFormAddTitle => 'Medikament hinzufügen';

  @override
  String get updateDetails => 'Details aktualisieren';

  @override
  String get medicineDetails => 'Medikamentendetails';

  @override
  String get medicineNameLabel => 'Medikamentenname';

  @override
  String get medicineNameHint => 'z. B. Metformin';

  @override
  String get nameRequired => 'Name ist erforderlich';

  @override
  String get dosageLabel => 'Dosierung';

  @override
  String get dosageHint => 'z. B. 500 mg';

  @override
  String get dosageRequired => 'Dosierung ist erforderlich';

  @override
  String get frequencyLabel => 'Häufigkeit';

  @override
  String get frequencyDaily => 'Täglich';

  @override
  String get frequencySpecificDays => 'Bestimmte Tage';

  @override
  String get daysLabel => 'Tage';

  @override
  String get timesLabel => 'Zeiten';

  @override
  String get addTime => 'Zeit hinzufügen';

  @override
  String get startDateLabel => 'Startdatum';

  @override
  String get endDateOptionalLabel => 'Enddatum (optional)';

  @override
  String get selectDate => 'Datum auswählen';

  @override
  String get pauseHint =>
      'Deaktiviere dies, um Erinnerungen zu pausieren, ohne das Medikament zu löschen';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get saveMedicine => 'Medikament speichern';

  @override
  String get selectAtLeastOneDay => 'Mindestens einen Tag auswählen';

  @override
  String get selectAtLeastOneTime => 'Mindestens eine Uhrzeit auswählen';

  @override
  String get startDateRequired => 'Startdatum ist erforderlich';

  @override
  String get endDateAfterStart => 'Enddatum muss nach dem Startdatum liegen';

  @override
  String get statusTaken => 'Eingenommen';

  @override
  String get statusMissed => 'Verpasst';

  @override
  String get statusSnoozed => 'Verschoben';

  @override
  String get snoozeLabel => 'Später';

  @override
  String get snooze15 => '15 Min.';

  @override
  String get snooze30 => '30 Min.';

  @override
  String get snooze60 => '1 Std.';

  @override
  String nextReminder(Object time) {
    return 'Nächste Erinnerung: $time';
  }

  @override
  String timeToTake(Object dosage) {
    return 'Zeit für $dosage';
  }

  @override
  String get notificationActionTaken => 'Eingenommen';

  @override
  String get notificationActionSnooze => 'Später';

  @override
  String get notificationChannelName => 'Medikamentenerinnerungen';

  @override
  String get notificationChannelDescription => 'Erinnerungen für Medikamente';

  @override
  String get fallbackMedicineName => 'Medikament';

  @override
  String dosesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dosen',
      one: '1 Dosis',
    );
    return '$_temp0';
  }

  @override
  String get snackMedicineAdded => 'Medikament hinzugefügt';

  @override
  String get snackMedicineUpdated => 'Medikament aktualisiert';

  @override
  String get snackMedicineDeleted => 'Medikament gelöscht';

  @override
  String get snackMarkedTaken => 'Als eingenommen markiert';

  @override
  String get snackMarkedMissed => 'Als verpasst markiert';

  @override
  String snackSnoozed(int minutes) {
    return 'Verschoben um $minutes Min.';
  }
}

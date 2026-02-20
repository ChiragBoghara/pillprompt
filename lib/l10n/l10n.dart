import 'package:flutter/widgets.dart';
import 'package:pillprompt/l10n/app_localizations.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

AppLocalizations appLocalizationsFor(Locale? locale) {
  final languageCode = locale?.languageCode ?? 'en';
  if (languageCode == 'de') {
    return lookupAppLocalizations(const Locale('de'));
  }
  return lookupAppLocalizations(const Locale('en'));
}

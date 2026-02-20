import 'package:pillprompt/l10n/app_localizations.dart';

import '../constants/domain_constants.dart';

String frequencyLabel(AppLocalizations l10n, String frequency) {
  switch (MedicineFrequency.normalize(frequency)) {
    case MedicineFrequency.specificDays:
      return l10n.frequencySpecificDays;
    case MedicineFrequency.daily:
    default:
      return l10n.frequencyDaily;
  }
}

String statusLabel(AppLocalizations l10n, String status) {
  switch (LogStatus.normalize(status)) {
    case LogStatus.taken:
      return l10n.statusTaken;
    case LogStatus.missed:
      return l10n.statusMissed;
    case LogStatus.snoozed:
      return l10n.statusSnoozed;
    default:
      return l10n.upcoming;
  }
}

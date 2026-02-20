abstract final class MedicineFrequency {
  static const String daily = 'daily';
  static const String specificDays = 'specific_days';

  static String normalize(String value) {
    switch (value.trim().toLowerCase()) {
      case 'daily':
        return daily;
      case 'specific_days':
        return specificDays;
      default:
        return daily;
    }
  }
}

abstract final class LogStatus {
  static const String taken = 'taken';
  static const String missed = 'missed';
  static const String snoozed = 'snoozed';

  static String normalize(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'taken':
        return taken;
      case 'missed':
        return missed;
      case 'snoozed':
        return snoozed;
      default:
        return normalized;
    }
  }
}

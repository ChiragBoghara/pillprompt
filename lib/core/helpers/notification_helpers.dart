class NotificationHelpers {
  static int buildNotificationId(int medicineId, String timeLabel) {
    final hash = '$medicineId-$timeLabel'.hashCode;
    return hash & 0x7fffffff;
  }
}

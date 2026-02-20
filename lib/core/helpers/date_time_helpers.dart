import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelpers {
  static final DateFormat _storageDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _storageTimeFormat = DateFormat('HH:mm');

  static String formatDate(DateTime date, {String? locale}) {
    return DateFormat.yMMMd(locale).format(date);
  }

  static String formatTimeOfDay(TimeOfDay time, {String? locale}) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat.jm(locale).format(dateTime);
  }

  static String formatDateForStorage(DateTime date) {
    return _storageDateFormat.format(date);
  }

  static String formatTimeForStorage(TimeOfDay time) {
    final value = DateTime(2000, 1, 1, time.hour, time.minute);
    return _storageTimeFormat.format(value);
  }

  static TimeOfDay parseTimeForStorage(String value) {
    final parsed = value.trim();
    final dateTime = _storageTimeFormat.parseStrict(parsed);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static String encodeTimes(List<TimeOfDay> times) {
    return times.map(formatTimeForStorage).toList().join('|');
  }

  static List<TimeOfDay> decodeTimes(String? encoded) {
    if (encoded == null || encoded.trim().isEmpty) return [];
    return encoded.split('|').map(parseTimeForStorage).toList();
  }

  static String encodeWeekdays(List<int> days) {
    if (days.isEmpty) return '';
    return days.join(',');
  }

  static List<int> decodeWeekdays(String? encoded) {
    if (encoded == null || encoded.trim().isEmpty) return [];
    return encoded.split(',').map((value) => int.parse(value)).toList();
  }

  static String weekdayShortName(int weekday, {String? locale}) {
    final baseMonday = DateTime.utc(2024, 1, 1);
    return DateFormat.E(
      locale,
    ).format(baseMonday.add(Duration(days: weekday - 1)));
  }
}

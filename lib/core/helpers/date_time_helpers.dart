import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelpers {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormat = DateFormat('h:mm a');

  static String formatDate(DateTime date) => _dateFormat.format(date);

  static String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return _timeFormat.format(dateTime);
  }

  static TimeOfDay parseTime(String value) {
    final dateTime = _timeFormat.parse(value);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static String encodeTimes(List<TimeOfDay> times) {
    return times.map(formatTimeOfDay).toList().join('|');
  }

  static List<TimeOfDay> decodeTimes(String? encoded) {
    if (encoded == null || encoded.trim().isEmpty) return [];
    return encoded.split('|').map(parseTime).toList();
  }

  static String encodeWeekdays(List<int> days) {
    if (days.isEmpty) return '';
    return days.join(',');
  }

  static List<int> decodeWeekdays(String? encoded) {
    if (encoded == null || encoded.trim().isEmpty) return [];
    return encoded.split(',').map((value) => int.parse(value)).toList();
  }
}

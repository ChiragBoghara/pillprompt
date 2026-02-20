import 'package:flutter/material.dart';

import '../../core/constants/domain_constants.dart';
import '../../core/helpers/date_time_helpers.dart';

class Medicine {
  final int? id;
  final String name;
  final String dosage;
  final String frequency;
  final List<TimeOfDay> times;
  final List<int> days;
  final DateTime startDate;
  final DateTime? endDate;
  final bool beforeFood;
  final bool isActive;

  const Medicine({
    this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.days,
    required this.startDate,
    this.endDate,
    required this.beforeFood,
    required this.isActive,
  });

  Medicine copyWith({
    int? id,
    String? name,
    String? dosage,
    String? frequency,
    List<TimeOfDay>? times,
    List<int>? days,
    DateTime? startDate,
    DateTime? endDate,
    bool? beforeFood,
    bool? isActive,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      days: days ?? this.days,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      beforeFood: beforeFood ?? this.beforeFood,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': MedicineFrequency.normalize(frequency),
      'times': DateTimeHelpers.encodeTimes(times),
      'days': DateTimeHelpers.encodeWeekdays(days),
      'start_date': DateTimeHelpers.formatDateForStorage(startDate),
      'end_date': endDate != null
          ? DateTimeHelpers.formatDateForStorage(endDate!)
          : null,
      'before_food': beforeFood ? 1 : 0,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Medicine.fromMap(Map<String, Object?> map) {
    return Medicine(
      id: map['id'] as int?,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      frequency: MedicineFrequency.normalize(map['frequency'] as String),
      times: DateTimeHelpers.decodeTimes(map['times'] as String?),
      days: DateTimeHelpers.decodeWeekdays(map['days'] as String?),
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: map['end_date'] == null
          ? null
          : DateTime.parse(map['end_date'] as String),
      beforeFood: (map['before_food'] as int) == 1,
      isActive: (map['is_active'] as int) == 1,
    );
  }
}

class MedicineLog {
  final int? id;
  final int medicineId;
  final String scheduledTime;
  final String status;
  final DateTime date;

  const MedicineLog({
    this.id,
    required this.medicineId,
    required this.scheduledTime,
    required this.status,
    required this.date,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'medicine_id': medicineId,
      'scheduled_time': scheduledTime,
      'status': status,
      'date': date.toIso8601String(),
    };
  }

  factory MedicineLog.fromMap(Map<String, Object?> map) {
    return MedicineLog(
      id: map['id'] as int?,
      medicineId: map['medicine_id'] as int,
      scheduledTime: map['scheduled_time'] as String,
      status: map['status'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}

class MedicineLogEntry {
  final int id;
  final int medicineId;
  final String medicineName;
  final String dosage;
  final String scheduledTime;
  final String status;
  final DateTime date;

  const MedicineLogEntry({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.dosage,
    required this.scheduledTime,
    required this.status,
    required this.date,
  });

  factory MedicineLogEntry.fromMap(Map<String, Object?> map) {
    return MedicineLogEntry(
      id: map['id'] as int,
      medicineId: map['medicine_id'] as int,
      medicineName: map['medicine_name'] as String,
      dosage: map['dosage'] as String,
      scheduledTime: map['scheduled_time'] as String,
      status: map['status'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }
}

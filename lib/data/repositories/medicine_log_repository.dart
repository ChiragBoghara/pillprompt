import '../../core/constants/app_constants.dart';
import '../db/app_database.dart';
import '../models/medicine_log.dart';
import '../models/medicine_log_entry.dart';

class MedicineLogRepository {
  MedicineLogRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<int> insert(MedicineLog log) async {
    final db = await _database.database;
    return db.insert(AppConstants.tableLogs, log.toMap());
  }

  Future<List<MedicineLog>> getByMedicine(int medicineId) async {
    final db = await _database.database;
    final results = await db.query(
      AppConstants.tableLogs,
      where: 'medicine_id = ?',
      whereArgs: [medicineId],
      orderBy: 'date DESC',
    );
    return results.map(MedicineLog.fromMap).toList();
  }

  Future<List<MedicineLog>> getByDateRange(DateTime start, DateTime end) async {
    final db = await _database.database;
    final results = await db.query(
      AppConstants.tableLogs,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return results.map(MedicineLog.fromMap).toList();
  }

  Future<List<MedicineLogEntry>> getAllWithMedicine() async {
    final db = await _database.database;
    final results = await db.rawQuery('''
      SELECT l.id, l.medicine_id, l.scheduled_time, l.status, l.date,
             m.name AS medicine_name, m.dosage AS dosage
      FROM ${AppConstants.tableLogs} l
      INNER JOIN ${AppConstants.tableMedicines} m
      ON l.medicine_id = m.id
      ORDER BY l.date DESC
    ''');
    return results.map(MedicineLogEntry.fromMap).toList();
  }
}

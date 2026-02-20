import '../../core/constants/app_constants.dart';
import '../db/app_database.dart';
import '../models/medicine.dart';

class MedicineRepository {
  MedicineRepository({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<int> insert(Medicine medicine) async {
    final db = await _database.database;
    return db.insert(AppConstants.tableMedicines, medicine.toMap());
  }

  Future<int> update(Medicine medicine) async {
    final db = await _database.database;
    return db.update(
      AppConstants.tableMedicines,
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _database.database;
    return db.delete(
      AppConstants.tableMedicines,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Medicine>> getAll() async {
    final db = await _database.database;
    final results = await db.query(
      AppConstants.tableMedicines,
      orderBy: 'id DESC',
    );
    return results.map(Medicine.fromMap).toList();
  }

  Future<List<Medicine>> getActive() async {
    final db = await _database.database;
    final results = await db.query(
      AppConstants.tableMedicines,
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );
    return results.map(Medicine.fromMap).toList();
  }

  Future<Medicine?> getById(int id) async {
    final db = await _database.database;
    final results = await db.query(
      AppConstants.tableMedicines,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Medicine.fromMap(results.first);
  }
}

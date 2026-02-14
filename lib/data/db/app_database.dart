import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/constants/app_constants.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();
  Database? _database;

  Future<Database> get database async {
    _database ??= await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);

    return openDatabase(
      path,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${AppConstants.tableMedicines} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            dosage TEXT NOT NULL,
            frequency TEXT NOT NULL,
            times TEXT NOT NULL,
            days TEXT,
            start_date TEXT NOT NULL,
            end_date TEXT,
            before_food INTEGER NOT NULL,
            is_active INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE ${AppConstants.tableLogs} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            medicine_id INTEGER NOT NULL,
            scheduled_time TEXT NOT NULL,
            status TEXT NOT NULL,
            date TEXT NOT NULL,
            FOREIGN KEY(medicine_id) REFERENCES ${AppConstants.tableMedicines}(id) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Check if column already exists before adding it
          final result = await db.rawQuery('PRAGMA table_info(${AppConstants.tableMedicines})');
          final columnExists = result.any((col) => col['name'] == 'days');

          if (!columnExists) {
            await db.execute('ALTER TABLE ${AppConstants.tableMedicines} ADD COLUMN days TEXT');
          }
        }
      },
    );
  }
}

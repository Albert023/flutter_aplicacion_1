import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/gastos.dart';

class GastosServices {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await iniciarDB();
    return _database!;
  }

  Future<Database> iniciarDB() async {
    final path = join(await getDatabasesPath(), 'gastos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE gastos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            descripcion TEXT,
            categoria TEXT,
            monto REAL,
            fecha TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertGasto(Gastos gastos) async {
    final db = await database;
    return await db.insert('gastos', gastos.toMap());
  }

  Future<List<Gastos>> getGastos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('gastos');
    return maps.map((map) => Gastos.fromMap(map)).toList();
  }

  Future<int> actualizarGastos(Gastos gastos) async {
    final db = await database;
    return await db.update(
      'gastos',
      gastos.toMap(),
      where: 'id = ?',
      whereArgs: [gastos.id],
    );
  }

  Future<int> eliminarGastos(int id) async {
    final db = await database;
    return await db.delete('gastos', where: 'id = ?', whereArgs: [id]);
  }
}

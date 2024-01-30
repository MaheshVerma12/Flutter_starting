import 'package:login/to_do/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ulid/ulid.dart';

class DatabaseServices {
  Database? _dbInstance;
  int _dbVersion = 1;
  String _databaseName = "note.db";
  String _tableName = "note";
  String _tableId = "id";
  String _tableTitle = "title";
  String _tableDescription = "description";
  Future<Database> get dbInstance async {
    if (_dbInstance == null) {
      final path = await getDatabasesPath();
      _dbInstance = await openDatabase(
        "$path/$_databaseName",
        version: _dbVersion,
        onCreate: (db, version) {
          db.execute(
              'CREATE TABLE $_tableName ($_tableId TEXT PRIMARY KEY, $_tableTitle TEXT, $_tableDescription TEXT)');
        },
      );
    }
    return _dbInstance!;
  }

  Future<void> addNote(
      {required String title, required String description}) async {
    final db = await dbInstance;
    await db.insert(_tableName, {
      _tableId: Ulid().toUuid(),
      _tableTitle: title,
      _tableDescription: description,
    });
  }

  Future<List<Todo>> getNote() async {
    final db = await dbInstance;
    final response = await db.query(_tableName);
    return response.map((e) => Todo.fromDBMap(e)).toList();
  }

  Future<void> updateNote(
      {required String title,
      required String description,
      required String id}) async {
    final db = await dbInstance;
    await db.update(
      _tableName,
      {
        _tableTitle: title,
        _tableDescription: description,
      },
      where: "$_tableId=?",
      whereArgs: [id],
    );
  }

  Future<void> deleteNote({required String id}) async {
    final db = await dbInstance;
    await db.delete(
      _tableName,
      where: "$_tableId=?",
      whereArgs: [id],
    );
  }
}

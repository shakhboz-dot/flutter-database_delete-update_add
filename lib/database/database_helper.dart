import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter44/model/category.dart';
import 'package:flutter44/model/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;
  static Database? _database;

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._internal();
      return _dataBaseHelper!;
    } else {
      return _dataBaseHelper!;
    }
  }

  DataBaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initialDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future _initialDatabase() async {
    // Agarda database bloklansa lock synxronize orqali ochib oladi
    var lock = Lock();
    Database? _db;

    // Database null kelsa uni lock orqali ochadi
    if (_db == null) {
      await lock.synchronized(() async {
        // lockdan ochgandan so'ng null kelsa yangi database kiritadi

        if (_db == null) {
          var databasePath = await getDatabasesPath();
          String path = join(databasePath, 'category.db');
          print("Db ning Pathi :" + path.toString());
          var file = File(path);

          if (!await file.exists()) {
            ByteData data =
                await rootBundle.load(join('assets', 'category.db'));
            List<int> bytes =
                data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
            await File(path).writeAsBytes(bytes);
          }
          _db = await openDatabase(path);
        }
      });
    }
    return _db;
  }

   Future<List<Map<String, dynamic>>> kategoriyalarniOlibKel() async {
    var db = await _getDatabase();
    var result = await db.query('category');
    print(result.toString());
    return result;
  }

  Future<int> categoryAdd(Category ctg) async {
    var db = await _getDatabase();
    var result = await db.insert('category', ctg.toMap());
    return result;
  }

  Future<int> categoryUpdate(Category ctg) async {
    var db = await _getDatabase();
    var result = await db.update('category', ctg.toMap(),
        where: 'categoryID = ?', whereArgs: [ctg.categoryID]);
    return result;
  }

  Future<int> categoryDelete(int ctgID) async {
    var db = await _getDatabase();
    var result = await db
        .delete('category', where: 'categoryID = ?', whereArgs: [ctgID]);
    return result;
  }

  Future<List<Map<String, dynamic>>> noteniOlibKel() async {
    var db = await _getDatabase();
    var result = await db.query('note',orderBy: 'noteID DESC');

    return result;
  }

  Future<int> noteAdd(Note nt) async {
    var db = await _getDatabase();
    var result = await db.insert('note', nt.toMap());
    return result;
  }

  Future<int> noteUpdate(Note nt) async {
    var db = await _getDatabase();
    var result = await db.update('note', nt.toMap(),
        where: 'noteID = ?', whereArgs: [nt.noteID]);
    return result;
  }

  Future<int> noteDelete(int ntID) async {
    var db = await _getDatabase();
    var result =
        await db.delete('note', where: 'noteID = ?', whereArgs: [ntID]);
    return result;
  }
}

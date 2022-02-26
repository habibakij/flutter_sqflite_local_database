
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_db/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance= DatabaseHelper._privateConstructor();
  Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory directory= await getApplicationDocumentsDirectory();
    String path= join(directory.path, 'userDatabase.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE userDatabase(
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
  }

  Future<List<User>> getUsers() async{
    Database database= await instance.database;
    var users= await database.query('userDatabase', orderBy: 'name');
    List<User> userList= users.isNotEmpty ? users.map((e) => User.fromMap(e)).toList() : [];
    return userList;
  }

  Future<int> add(User user) async{
    Database database= await instance.database;
    return await database.insert('userDatabase', user.toMap());
  }

  Future<int> remove(int id) async{
    Database database= await instance.database;
    return await database.delete('userDatabase', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async{
    Database database= await instance.database;
    return await database.update('userDatabase', user.toMap(), where: 'id = ?', whereArgs: [user.id!]);
  }

}
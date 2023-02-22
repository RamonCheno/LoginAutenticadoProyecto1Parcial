// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import '../model/user_model.dart';

class DBHelper {
  static Database? _db;

  static const String dbName = 'ProyectoParcial1.db';
  static const String tableUser = 'Usuarios';
  static const int version = 1;

  static const String cUserName = 'Nombre_Usuario';
  static const String cFullName = 'Nombre_Completo';
  static const String cEmail = 'Correo';
  static const String cPassword = 'Contrasena';
  static const String cRolUser = 'Rol';

  Future<Database> get db async => _db ??= await initDB();

  Future<Database> initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    Database db =
        await openDatabase(path, version: version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute('''
      Create Table $tableUser (
      $cUserName TEXT PRiMARY KEY UNIQUE,
      $cFullName TEXT,
      $cEmail TEXT UNIQUE,
      $cPassword TEXT,
      $cRolUser TEXT
    )''');
  }

  Future<int> saveData(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient.insert(tableUser, user.toMap());
    return res;
  }

  Future<UserModel?> getLoginUsers(String userName, String password) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery('''Select * from $tableUser
      where $cUserName = ? AND $cPassword = ?''', [userName, password]);
    print('Usaurio: $res');
    if (res.isEmpty) {
      return null;
    }
    return UserModel.formMap(res.first);
  }

  Future<List<UserModel>> allUsers() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> res = await dbClient.query(tableUser);
    return List.generate(res.length, (index){
      return UserModel(fullName: res[index]['Nombre_Completo'], email: res[index]['Correo'], password: res[index]['Contrasena'], userName: res[index]['Nombre_Usuario'], rol: res[index]['Rol']);
    });
  }
}

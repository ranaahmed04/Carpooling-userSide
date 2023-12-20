import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  late Database _database;

  Future<void> initialize() async {
    final String path = join(await getDatabasesPath(), 'user_database.db');
    print('joined');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE user(
            id INTEGER PRIMARY KEY,
            email TEXT,
            phoneNumber TEXT,
            username TEXT
          )
        ''');
      },
    );
    print('opened');
  }

  Future<void> printDatabaseContent() async {
    if (_database == null) {
      print('Database is not yet initialized');
      return;
    }

    final List<Map<String, dynamic>> queryResult = await _database.query('user');
    if (queryResult.isNotEmpty) {
      print('anaaa mawgood ahoooo');
      queryResult.forEach((row) {
        print('User data: $row');
      });
    } else {
      print('No USER DATA AVLIABLE');
    }
  }

  // Incorporating MyDatabase functionality into DatabaseService
  Future<Database?> checkData() async {
    if (_database == null) {
      print('initializing');
      await initialize(); // Ensure database is initialized
      return _database;
    } else {
      print('initialized already');
      return _database;
    }
  }

  Future<void> resetDatabase() async {
    final String path = join(await getDatabasesPath(), 'user_database.db');
    await deleteDatabase(path);
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
           CREATE TABLE user(
            id INTEGER PRIMARY KEY,
            email TEXT,
            phoneNumber TEXT,
            username TEXT
          )
        ''');
      },
    );
  }

  Future<void> syncFirestoreDataToSQLite(Map<String, dynamic> userData) async {
    if (_database == null) {
      print('Database is not yet initialized');
      return;
    }

    print('syncing');
    if (userData.containsKey('password')) {
      userData.remove('password');
    }

    List<Map<String, dynamic>> existingData = await _database.query('user');
    if (existingData.isNotEmpty) {
      print('data not empty');
      // Update the existing data
      await _database.update('user', userData);
    } else {
      // Insert the new data
      print('mafesh');
      await _database.insert('user', userData);
    }

    print('synced');
  }



  Future<Map<String, dynamic>> fetchUserDataFromSQLite() async {
    if (_database == null) {
      print('Database is not yet initialized');
      return {};
    }
    print('fetchUserDataFromSQLite');
    final List<Map<String, dynamic>> queryResult = await _database.query('user');
    if (queryResult.isNotEmpty) {
      print('fetched');
      print(queryResult.first);
      return queryResult.first;
    }
    return {};
  }
}
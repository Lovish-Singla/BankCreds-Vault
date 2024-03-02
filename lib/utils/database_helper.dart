import 'dart:io';

import 'package:bank_credentials/models/organisation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;
  static DBHelper? _dbHelper;

  String noteTable = "credentials";
  // String colId = "ID";
  String colOrg = "name";
  String colAcc = "accountNumber";
  String colIfsc = "ifscCode";
  String colCity = "city";
  String colState = "state";
  String colPhone = "phoneNumber";
  String colDesc = "description";

  DBHelper._createInstance(); // Named Constructor for creating an instance of DBHelper.

  factory DBHelper() => _dbHelper ??= DBHelper._createInstance();

  Future<Database> get database async =>
      _database ??= await initializeDatabase();


  initializeDatabase() async {
    // Get the directory path for both Android to store the database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}credstore.db";

    // Open/create the database at the given path
    var credDatabase = openDatabase(path, version: 1, onCreate: _createdb);
    return credDatabase;
  }

  void _createdb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $noteTable ($colOrg TEXT PRIMARY KEY, $colAcc TEXT, $colIfsc TEXT, $colCity TEXT, $colState TEXT, $colPhone TEXT NULL, `$colDesc` TEXT NULL)");
    // Insert a dummy organization entry
    await db.insert(noteTable, {
      colOrg: 'ZZ Dummy Organization',
      colAcc: '1234567890',
      colIfsc: 'INDIA000000',
      colCity: 'Earth',
      colState: 'Milky Way Galaxy',
      colPhone: '9876543210',
      colDesc: 'This is a dummy organization for testing purposes.'
    });
  }

  // CRUD operations

  // Fetch operation: Get all Organization objects from database
  Future<List<Map<String, dynamic>>> getOrganisationMapList() async {
    Database db = await this.database;
    
    var result = await db.rawQuery("SELECT * FROM $noteTable ORDER BY $colOrg ASC");
    // var result = await db.query(noteTable, orderBy: '$colOrg ASC');
    return result;
  }

  // Insert operation: Insert a Organization object to database
  Future<int> insertOrganisation(Organization organization) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, organization.toMap());
    return result;
  }

  // Update Operation: Update a Organisation object and save it to the database
  Future<int> updateOrganisation(Organization organization) async {
    Database db = await this.database;
    var result = await db.update(noteTable, organization.toMap(), where: '$colOrg = ?', whereArgs: [organization.name]);
    return result;
  }

  // Delete operation: Delete a Organization object from database
  Future<int> deleteOrganisation(String organisationName) async {
    Database db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colOrg = "$organisationName"');
    return result;
  }

  // Get number of Organisation objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result ??= 0;
  }

  // A function to get the note list. As we know the objects that are stored in database are all maps.
  // The previous function gets the List of map objects from the database but we require the list of organisations.
  // So we are writing the function to get the list of organisations.
  Future<List<Organization>> getOrganisationList() async {
    var organisationMapList = await getOrganisationMapList();
    int count = organisationMapList.length;
    List<Organization> organisationList = List<Organization>.empty();
    
    for(int i = 0; i < count; i++){
      organisationList.add(Organization.fromMap(organisationMapList[i]));
    }
    return organisationList;
  }

}

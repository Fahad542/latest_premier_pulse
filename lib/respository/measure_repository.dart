import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/measures.dart';
import 'api_services.dart';

class measure_repository {
  final GetApiService _apiService = GetApiService();

  Future<Database> database() async {
    return openDatabase(
      // Set the path to the database file.
      join(await getDatabasesPath(), 'measure_database.db'),


      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE measures(id INTEGER PRIMARY KEY, measureName TEXT, measureGroupName TEXT, measureDisplayFolder TEXT)',
        );
      },

      version: 1,
    );
  }
  Future<void> clearMeasures() async {
    final Database db = await database();
    await db.delete('measures');
  }

  Future<void> saveMeasures(List<Measure> measures) async {
    final Database db = await database();

    // Insert the measures into the database.
    await db.transaction((txn) async {
      for (final measure in measures) {
        await txn.insert(
          'measures',
          measure.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<List<Measure>> fetchDataAndSave() async {
    final url = 'https://api.psplbi.com/api/measurenames';
    print(url);
    final requestData = [];

    final List<Measure> measures = await _apiService.getData(url, requestData, (data) =>
    List<Measure>.from(data.map((json) => Measure.fromJson(json)))
    );
    print("measure: ${measures}");
    await saveMeasures(measures);

    return measures;
  }
  Future<List<Measure>> getAllMeasures() async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db.query('measures');

    print("Maps : ${maps}");
    return List.generate(maps.length, (i) {
      return Measure(

        measureName: maps[i]['measureName'],
        measureGroupName: maps[i]['measureGroupName'],
        measureDisplayFolder: maps[i]['measureDisplayFolder'],
      );
    });
  }
  Future<void> printAllMeasures() async {
    final List<Measure> measures = await getAllMeasures();
    measures.forEach((measure) {
      print('Measure Name: ${measure.measureName}');
      print('Measure Group Name: ${measure.measureGroupName}');
      print('Measure Display Folder: ${measure.measureDisplayFolder}');
      print('-------------------------');
    });
  }
  Future<List<Measure>> getAllMeasuresGroupByGroupName() async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db.query(
      'measures',
      groupBy: 'measureGroupName',
    );

    // Convert the List<Map<String, dynamic>> into a List<Measure>.
    return List.generate(maps.length, (i) {
      return Measure(
        measureName: maps[i]['measureName'],
        measureGroupName: maps[i]['measureGroupName'],
        measureDisplayFolder: maps[i]['measureDisplayFolder'],
      );
    });
  }
  Future<List<String>> getDisplayFoldersByGroupName(String groupName) async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT measureDisplayFolder FROM measures WHERE measureGroupName = ?',
      [groupName],
    );
print("data1: $maps");


    return List.generate(maps.length, (i) {
      return maps[i]['measureDisplayFolder'];
    });
  }
  Future<List<String>> getDisplayFoldersByName(String groupName, String foldername) async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT measureName FROM measures WHERE measureDisplayFolder = ? AND measureGroupName = ?',
      [groupName,foldername], // Pass foldername first, then groupName
    );
    print("groupname: $groupName");
    print("foldername: $foldername");

    print("data2: $maps");


    // Extract the measureDisplayFolder values from the result.
    return List.generate(maps.length, (i) {
      return maps[i]['measureName'];
    });
  }




}

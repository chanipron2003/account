import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../models/tourist_attraction.dart';

class AttractionDB {
  String dbName;

  AttractionDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertAttraction(TouristAttraction attraction) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('attractions');

    var keyID = await store.add(db, {
      "name": attraction.name,
      "province": attraction.province,
      "date": attraction.date.toIso8601String(),
      "highlight": attraction.highlight,
      "feeling": attraction.feeling,
      "imagePath": attraction.imagePath,
    });
    await db.close();
    return keyID;
  }

  Future<List<TouristAttraction>> loadAllAttractions() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('attractions');
    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder(Field.key, false)]));
    List<TouristAttraction> attractions = [];
    for (var record in snapshot) {
      attractions.add(TouristAttraction(
        keyID: record.key,
        name: record['name'].toString(),
        province: record['province'].toString(),
        date: DateTime.parse(record['date'].toString()),
        highlight: record['highlight'].toString(),
        feeling: record['feeling'].toString(),
        imagePath: record['imagePath'].toString(),
      ));
    }
    await db.close();
    return attractions;
  }

  Future<void> deleteAttraction(int? keyID) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('attractions');
    await store.delete(db, finder: Finder(filter: Filter.equals(Field.key, keyID)));
    await db.close();
  }

  Future<void> updateAttraction(TouristAttraction attraction) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('attractions');
    await store.record(attraction.keyID!).update(db, {
      "name": attraction.name,
      "province": attraction.province,
      "date": attraction.date.toIso8601String(),
      "highlight": attraction.highlight,
      "feeling": attraction.feeling,
      "imagePath": attraction.imagePath,
    });
    await db.close();
  }
}

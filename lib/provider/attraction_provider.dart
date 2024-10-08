import 'package:flutter/foundation.dart';
import '../databases/attraction_db.dart';
import '../models/TouristAttraction.dart';

class AttractionProvider with ChangeNotifier {
  List<TouristAttraction> attractions = [];

  List<TouristAttraction> getAttractions() {
    return attractions;
  }

  void initData() async {
    var db = AttractionDB(dbName: 'attractions.db');
    attractions = await db.loadAllAttractions();
    notifyListeners();
  }

  void addAttraction(TouristAttraction attraction) async {
    var db = AttractionDB(dbName: 'attractions.db');
    await db.insertAttraction(attraction);
    attractions = await db.loadAllAttractions();
    notifyListeners();
  }

  void deleteAttraction(int? keyID) async {
    var db = AttractionDB(dbName: 'attractions.db');
    await db.deleteAttraction(keyID);
    attractions = await db.loadAllAttractions();
    notifyListeners();
  }

  void updateAttraction(TouristAttraction attraction) async {
    var db = AttractionDB(dbName: 'attractions.db');
    await db.updateAttraction(attraction);
    attractions = await db.loadAllAttractions();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/area.dart';
import '../database/area_database_helper.dart';

class AreaProvider with ChangeNotifier {
  List<Area> _areas = [];

  List<Area> get areas => _areas;

  Future<void> fetchAreas() async {
    final areasList = await AreaDatabaseHelper().getAreas();
    _areas = areasList;
    notifyListeners();
  }

  Future<void> addArea(Area area) async {
    await AreaDatabaseHelper().insertArea(area);
    await fetchAreas();
  }

  Future<void> updateArea(Area area) async {
    await AreaDatabaseHelper().updateArea(area);
    await fetchAreas();
  }

  Future<void> deleteArea(int areaId) async {
    await AreaDatabaseHelper().deleteArea(areaId);
    await fetchAreas();
  }
}

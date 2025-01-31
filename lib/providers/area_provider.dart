import 'package:flutter/material.dart';
import '../models/area.dart';
import '../database/area_database_helper.dart';

class AreaProvider with ChangeNotifier {
  List<Area> _areas = [];

  AreaProvider() {
    fetchAreas();
  }

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

  Future<void> updateArea(Area area, String newName) async {
    // Update the area object with the new name
    area.areaName = newName;

    await AreaDatabaseHelper().updateArea(area);
    await fetchAreas();
  }

  Future<void> deleteArea(int areaId) async {
    await AreaDatabaseHelper().deleteArea(areaId);
    await fetchAreas();
  }

  Future<void> fetchAreasByQuery(String query) async {
    final areasList = await AreaDatabaseHelper().getAreas(); // Fetch areas
    _areas = areasList
        .where(
            (area) => area.areaName.toLowerCase().contains(query.toLowerCase()))
        .toList(); // Filter by query
    notifyListeners(); // Notify listeners after updating the list
  }
}

import 'package:flutter/material.dart';
import '../models/area.dart';
import '../database/area_database_helper.dart';

class AreaProvider with ChangeNotifier {
  List<Area> _areas = [];

  // Constructor to fetch areas when the provider is initialized
  AreaProvider() {
    fetchAreas();
  }

  // Getter to retrieve the list of areas
  List<Area> get areas => _areas;

  // Fetches all areas from the database and updates the _areas list
  Future<void> fetchAreas() async {
    final areasList = await AreaDatabaseHelper().getAreas();
    _areas = areasList;
    notifyListeners(); // Notify listeners when the areas are updated
  }

  // Adds a new area to the database and refreshes the areas list
  Future<void> addArea(Area area) async {
    await AreaDatabaseHelper().insertArea(area);
    await fetchAreas(); // Refresh the areas list after adding
  }

  // Updates the area name and refreshes the areas list
  Future<void> updateArea(Area area, String newName) async {
    // Update the area object with the new name
    area.areaName = newName;

    await AreaDatabaseHelper().updateArea(area);
    await fetchAreas(); // Refresh the areas list after updating
  }

  // Deletes an area by its ID and refreshes the areas list
  Future<void> deleteArea(int areaId) async {
    await AreaDatabaseHelper().deleteArea(areaId);
    await fetchAreas(); // Refresh the areas list after deleting
  }

  // Fetches areas based on a search query and updates the _areas list
  Future<void> fetchAreasByQuery(String query) async {
    final areasList = await AreaDatabaseHelper().getAreas(); // Fetch areas
    _areas = areasList
        .where(
            (area) => area.areaName.toLowerCase().contains(query.toLowerCase()))
        .toList(); // Filter by query
    notifyListeners(); // Notify listeners after updating the list
  }
}

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:find_shop/database/area_database_helper.dart';
import 'package:find_shop/database/category_database_helper.dart';
import 'package:find_shop/models/area.dart';
import 'package:find_shop/models/category.dart';
import 'package:flutter/material.dart';

class UploadProvider with ChangeNotifier {
  bool isLoading = false;

  Future<void> uploadExcelFile(BuildContext context, String tableName) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      if (tableName == 'areas') {
        await _insertAreas(excel);
      } else if (tableName == 'categories') {
        await _insertCategories(excel);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$tableName data uploaded successfully!')),
        );
      }
      notifyListeners();
    }
  }

  Future<void> _insertAreas(Excel excel) async {
    AreaDatabaseHelper dbHelper = AreaDatabaseHelper();
    var sheet = excel.tables[excel.tables.keys.first]!;

    for (var row in sheet.rows.skip(1)) {
      if (row[1] != null) {
        String areaName = row[1]!.value.toString();
        await dbHelper.insertArea(Area(areaName: areaName));
      }
    }
  }

  Future<void> _insertCategories(Excel excel) async {
    CategoryDatabaseHelper dbHelper = CategoryDatabaseHelper();
    var sheet = excel.tables[excel.tables.keys.first]!;

    for (var row in sheet.rows.skip(1)) {
      if (row[1] != null) {
        String catName = row[1]!.value.toString();
        String? catDesc =
            row.length > 2 && row[2] != null ? row[2]!.value.toString() : null;
        await dbHelper
            .insertCategory(Category(catName: catName, catDesc: catDesc!));
      }
    }
  }
}

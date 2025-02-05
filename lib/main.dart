import 'package:find_shop/database/app_database.dart';
import 'package:find_shop/my_app.dart';
import 'package:flutter/material.dart';
import 'utils/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await AppDatabase().database;

  // Initialize SharedPreferences and check if the user is logged in
  bool isLoggedIn = await SharedPreferencesHelper().isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

import 'package:find_shop/database/app_database.dart';
import 'package:find_shop/my_app.dart';
import 'package:flutter/material.dart';
import 'utils/shared_preferences_helper.dart';

void main() async {
  // Ensures that Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase().database; // Initializes the database connection

  // Checks if the user is logged in by fetching the login status from SharedPreferences
  bool isLoggedIn = await SharedPreferencesHelper().isLoggedIn();

  // Runs the app and passes the login status to MyApp
  runApp(
    MyApp(
      isLoggedIn: isLoggedIn,
    ),
  );
}

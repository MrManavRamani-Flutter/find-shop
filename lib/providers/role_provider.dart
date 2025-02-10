import 'package:flutter/material.dart';
import '../models/role.dart';
import '../database/role_database_helper.dart';

class RoleProvider with ChangeNotifier {
  List<Role> _roles = [];

  List<Role> get roles => _roles;

  // Fetch all roles from the database
  Future<void> fetchRoles() async {
    final rolesList = await RoleDatabaseHelper().getRoles();
    _roles = rolesList;
    notifyListeners(); // Notify listeners to update the UI
  }

  // Add a new role to the database
  Future<void> addRole(Role role) async {
    await RoleDatabaseHelper().insertRole(role);
    await fetchRoles(); // Refresh the list of roles after adding
  }

  // Update an existing role in the database
  Future<void> updateRole(Role role) async {
    await RoleDatabaseHelper().updateRole(role);
    await fetchRoles(); // Refresh the list of roles after updating
  }

  // Delete a role from the database by its ID
  Future<void> deleteRole(int roleId) async {
    await RoleDatabaseHelper().deleteRole(roleId);
    await fetchRoles(); // Refresh the list of roles after deletion
  }
}

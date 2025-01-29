import 'package:flutter/material.dart';
import '../models/role.dart';
import '../database/role_database_helper.dart';

class RoleProvider with ChangeNotifier {
  List<Role> _roles = [];

  List<Role> get roles => _roles;

  Future<void> fetchRoles() async {
    final rolesList = await RoleDatabaseHelper().getRoles();
    _roles = rolesList;
    notifyListeners();
  }

  Future<void> addRole(Role role) async {
    await RoleDatabaseHelper().insertRole(role);
    await fetchRoles();
  }

  Future<void> updateRole(Role role) async {
    await RoleDatabaseHelper().updateRole(role);
    await fetchRoles();
  }

  Future<void> deleteRole(int roleId) async {
    await RoleDatabaseHelper().deleteRole(roleId);
    await fetchRoles();
  }
}

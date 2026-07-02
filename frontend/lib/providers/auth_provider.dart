import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class AuthProvider extends ChangeNotifier {
  static const String _userIdKey = "user_id";

  UserModel? _currentUser;

  bool _isLoading = false;

  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _isLoggedIn;

  /// ==========================
  /// Register User
  /// ==========================

  Future<bool> register({
    required String fullName,
    required String email,
    required String role,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await UserService.instance.register(
        fullName: fullName,
        email: email,
        role: role,
      );

      _currentUser = user;
      _isLoggedIn = true;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        _userIdKey,
        user.userId,
      );

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      debugPrint(e.toString());

      return false;
    }
  }

  /// ==========================
  /// Restore Login
  /// ==========================

  Future<void> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final id = prefs.getString(_userIdKey);

      if (id == null) {
        _isLoggedIn = false;
        notifyListeners();
        return;
      }

      _isLoading = true;
      notifyListeners();

      final user = await UserService.instance.getUser(id);

      _currentUser = user;
      _isLoggedIn = true;

      _isLoading = false;

      notifyListeners();
    } catch (e) {
      _currentUser = null;
      _isLoggedIn = false;
      _isLoading = false;

      notifyListeners();
    }
  }

  /// ==========================
  /// Logout
  /// ==========================

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userIdKey);

    _currentUser = null;

    _isLoggedIn = false;

    notifyListeners();
  }
}
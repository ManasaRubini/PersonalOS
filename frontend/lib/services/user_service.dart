import 'package:dio/dio.dart';

import '../models/user.dart';
import 'api_service.dart';

class UserService {
  UserService._();

  static final UserService instance = UserService._();

  /// ============================
  /// Register User
  /// POST /users/register
  /// ============================

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String role,
  }) async {
    try {
      final Response response = await ApiService.instance.post(
        "/users/register",
        data: {
          "full_name": fullName,
          "email": email,
          "role": role,
        },
      );

      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// ============================
  /// Get User
  /// GET /users/{id}
  /// ============================

  Future<UserModel> getUser(String userId) async {
    try {
      final Response response = await ApiService.instance.get(
        "/users/$userId",
      );

      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
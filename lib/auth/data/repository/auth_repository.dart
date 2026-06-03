import 'package:ao_1/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final Dio _dio = DioClient.instance;

  Future<bool> login({required String userName, required String password}) async {
    try {
      final response = await _dio.post('/api/auth/login', data: {
        'userName': userName,
        'password': password,
      });

      final token = response.data['token'] as String?;
      if (token == null) return false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      return true;
    } on DioException catch (e) {
      debugPrint('Login error: ${e.response?.statusCode} ${e.message}');
      return false;
    }
  }

  /// Devuelve null si el registro fue exitoso, o el mensaje de error real si falló.
  Future<String?> register({required String userName, required String password}) async {
    try {
      await _dio.post('/api/auth/register', data: {
        'userName': userName,
        'password': password,
      });
      return null;
    } on DioException catch (e) {
      debugPrint('Register error: ${e.response?.statusCode} ${e.message}');

      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
      return 'No se pudo conectar al servidor (${e.response?.statusCode ?? 'sin respuesta'})';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    DioClient.reset();
  }
}

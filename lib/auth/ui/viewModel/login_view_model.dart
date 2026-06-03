import 'package:ao_1/auth/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthRepository authRepository = AuthRepository();

  bool isAuthenticated = false;
  bool isLoading = false;
  String errorMessage = '';

  LoginViewModel();

  Future<void> initAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      isAuthenticated = token != null && token.isNotEmpty;
      notifyListeners();
    } catch (e) {
      isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> login() async {
    final userName = userNameController.text.trim();
    final password = passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      errorMessage = 'Complete todos los campos';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final success = await authRepository.login(userName: userName, password: password);

    isLoading = false;
    if (success) {
      isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticate', true);
    } else {
      errorMessage = 'Credenciales incorrectas';
    }
    notifyListeners();
  }

  Future<bool> register({required String userName, required String password}) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final error = await authRepository.register(userName: userName, password: password);

    isLoading = false;
    if (error != null) errorMessage = error;
    notifyListeners();
    return error == null;
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      isAuthenticated = false;
      errorMessage = '';
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isAuthenticate');
      notifyListeners();
    } catch (e) {
      debugPrint('Error al hacer logout: $e');
    }
  }
}

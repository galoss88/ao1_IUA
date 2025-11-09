import 'package:ao_1/auth/data/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthRepository authRepository = AuthRepository();
  
  bool isAuthenticated = false;
  String errorMessage = '';
  
  LoginViewModel();

  Future<void> initAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuthenticateShared = prefs.getBool("isAuthenticate");
      isAuthenticated = isAuthenticateShared ?? false;
      notifyListeners();
    } catch (e) {
      isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    print('Intentando login con: $email y $password');

    if (email.isEmpty || password.isEmpty) {
      errorMessage = "Complete todos los campos";
      notifyListeners();
      return;
    }

    bool success = await authRepository.login(email: email, password: password);
    print('Resultado del login: $success');

    if (success) {
      isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isAuthenticate", true);
      errorMessage = '';
      print('Login exitoso!');
    } else {
      errorMessage = "Credenciales incorrectas";
      print('Login fallido');
    }
    notifyListeners();

  }

  Future<void> logout() async {
    try {
      isAuthenticated = false;
      errorMessage = '';
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("isAuthenticate");
      notifyListeners();
    } catch (e) {
      print('Error al hacer logout: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

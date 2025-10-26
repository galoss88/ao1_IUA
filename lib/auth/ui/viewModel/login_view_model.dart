import 'package:flutter/material.dart';
import 'package:ao_1/auth/data/repository/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthRepository authRepository = AuthRepository();
  
  bool isAuthenticated = false;
  String errorMessage = '';

  void login() {
    String email = emailController.text;
    String password = passwordController.text;
    
    print('Intentando login con: $email y $password');
    
    if (email.isEmpty || password.isEmpty) {
      errorMessage = "Complete todos los campos";
      notifyListeners();
      return;
    }
    
    bool success = authRepository.login(email: email, password: password);
    print('Resultado del login: $success');
    
    if (success) {
      isAuthenticated = true;
      errorMessage = '';
      print('Login exitoso!');
    } else {
      errorMessage = "Credenciales incorrectas";
      print('Login fallido');
    }
    
    notifyListeners();
  }
}
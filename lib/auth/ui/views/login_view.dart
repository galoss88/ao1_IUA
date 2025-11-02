import 'package:ao_1/auth/ui/viewModel/login_view_model.dart';
import 'package:ao_1/auth/ui/widgets/container_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    // Usar el LoginViewModel del MultiProvider, no crear uno nuevo
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Expanded(child: ContainerLoginWidget()),
                if (loginViewModel.errorMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      loginViewModel.errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

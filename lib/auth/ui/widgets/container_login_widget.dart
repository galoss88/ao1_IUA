import 'package:ao_1/auth/ui/widgets/header_login_widget.dart';
import 'package:ao_1/auth/ui/widgets/login_inputs_widget.dart';
import 'package:ao_1/auth/ui/viewModel/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContainerLoginWidget extends StatelessWidget {
  const ContainerLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return Column(
          children: [
            const HeaderLoginWidget(),
            LoginInputs(
              onLoginPressed: () async {
                print('Botón presionado!');
                // El listener en main.dart manejará la navegación automáticamente
                await loginViewModel.login();
              },
              emailController: loginViewModel.emailController,
              passwordController: loginViewModel.passwordController,
            ),
          ],
        );
      },
    );
  }
}

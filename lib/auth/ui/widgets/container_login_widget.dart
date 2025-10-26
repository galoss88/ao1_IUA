import 'package:ao_1/auth/ui/widgets/header_login_widget.dart';
import 'package:ao_1/auth/ui/widgets/login_inputs_widget.dart';
import 'package:ao_1/auth/ui/viewModel/login_view_model.dart';
import 'package:ao_1/contact/ui/views/list-contacts-view.dart';
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
              onLoginPressed: () {
                print('Botón presionado!');
                loginViewModel.login();
                
                // Si el login es exitoso, navegar
                if (loginViewModel.isAuthenticated) {
                  print('Navegando a contactos...');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListContactsView(),
                    ),
                  );
                }
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

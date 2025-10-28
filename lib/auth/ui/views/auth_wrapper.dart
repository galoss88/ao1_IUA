import 'package:ao_1/auth/ui/viewModel/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginViewModel = context.read<LoginViewModel>();
      await loginViewModel.initAuth();
      final routeName = loginViewModel.isAuthenticated
          ? '/listContacts'
          : '/login';
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

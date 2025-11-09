import 'package:ao_1/auth/ui/viewModel/login_view_model.dart';
import 'package:ao_1/auth/ui/views/login_view.dart';
import 'package:ao_1/contact/ui/views/list-contacts-view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final loginViewModel = context.read<LoginViewModel>();
    await loginViewModel.initAuth();
    
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        if (loginViewModel.isAuthenticated) {
          return const ListContactsView();
        }
        return const LoginView();
      },
    );
  }
}

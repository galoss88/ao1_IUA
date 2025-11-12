import 'package:ao_1/auth/ui/viewModel/login_view_model.dart';
import 'package:ao_1/auth/ui/views/auth_wrapper.dart';
import 'package:ao_1/auth/ui/views/login_view.dart';
import 'package:ao_1/contact/ui/viewModel/contacts_view_model.dart';
import 'package:ao_1/contact/ui/views/contacts-view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContactViewModel()),
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SafeArea(child: AuthWrapper()),
      routes: {
        "/login": (_) => const SafeArea(child: LoginView()),
        "/listContacts": (_) => const SafeArea(child: ListContactsView()),
      },
    );
  }
}

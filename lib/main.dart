import 'package:ao_1/auth/ui/views/login_view.dart';
import 'package:ao_1/contact/ui/viewModel/contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ContactViewModel()),
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
      routes: {"/": (_) => const SafeArea(child: LoginView())},
      initialRoute: "/",
    );
  }
}

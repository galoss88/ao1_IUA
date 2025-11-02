import 'package:ao_1/auth/ui/viewModel/login_view_model.dart';
import 'package:ao_1/auth/ui/views/auth_wrapper.dart';
import 'package:ao_1/auth/ui/views/login_view.dart';
import 'package:ao_1/contact/ui/viewModel/contact_view_model.dart';
import 'package:ao_1/contact/ui/views/list-contacts-view.dart';
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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Paso 3: Crear un "control remoto" del Navigator
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Paso 4: Escuchar cambios en LoginViewModel cuando el widget se crea
    // El context ya está disponible en initState, no necesitamos addPostFrameCallback aquí
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    loginViewModel.addListener(_handleAuthChange);
  }

  @override
  void dispose() {
    // Paso 6: Limpiar el listener cuando el widget se destruye
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    loginViewModel.removeListener(_handleAuthChange);
    super.dispose();
  }

  // Paso 5: Método que se ejecuta cuando isAuthenticated cambia
  void _handleAuthChange() {
    // Verificar que el widget esté montado antes de acceder al context
    if (!mounted) return;
    
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Verificar nuevamente que el widget siga montado
      if (!mounted || navigatorKey.currentState == null) return;
      
      if (!loginViewModel.isAuthenticated) {
        // Si el usuario cerró sesión, navegar al login
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      } else {
        // Si el usuario inició sesión, navegar a listContacts
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          '/listContacts',
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Paso 7: Conectar el control remoto al Navigator
      navigatorKey: navigatorKey,
      routes: {
        "/": (_) => const SafeArea(child: AuthWrapper()),
        "/login": (_) => const SafeArea(child: LoginView()),
        "/listContacts": (_) => const SafeArea(child: ListContactsView()),
      },
      initialRoute: "/",
    );
  }
}

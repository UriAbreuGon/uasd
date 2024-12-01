import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'eventos_page.dart';
import 'mis_tareas_page.dart';
import 'register_page.dart';         // Importa la página de Registro
import 'forgot_password_page.dart'; // Importa la página de Olvidar Contraseña
import 'user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/eventos': (context) => EventosPage(),
        '/tareas': (context) => MisTareasPage(),
        '/register': (context) => RegisterPage(),           // Ruta para Registro
        '/forgot_password': (context) => ForgetPasswordPage(),
        '/user': (context) => UserPage() // Ruta para Olvidar Contraseña
      },
    );
  }
}

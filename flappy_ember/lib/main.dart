import 'package:flappy_ember/setupscreen.dart';
import 'package:flutter/material.dart'; // Asegúrate de importar la pantalla de configuración aquí

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Ember Setup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SetupScreen(), // Usamos SetupScreen como pantalla inicial
    );
  }
}


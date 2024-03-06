import 'package:flappy_ember/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'setupscreen.dart'; // Asegúrate de tener la ruta correcta
// Asegúrate de tener la ruta correcta

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MyApp(),
    ),
  );
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

import 'package:flappy_ember/app.dart';
import 'package:flappy_ember/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'setupscreen.dart'; // Asegúrate de tener la ruta correcta
// Asegúrate de tener la ruta correcta

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: const App(),
    ),
  );
}

import 'package:flappy_ember/setupscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flappy_ember/appdata.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Flappy Ember',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SetupScreen(),
      ),
    ),
  );
}

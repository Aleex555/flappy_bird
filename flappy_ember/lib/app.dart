import 'package:flappy_ember/appdata.dart';
import 'package:flappy_ember/players_screen.dart';
import 'package:flappy_ember/setupscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Main application widget
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

// Main application state
class AppState extends State<App> {
  // Definir el contingut del widget 'App'

  Widget _setLayout(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    switch (appData.connectionStatus) {
      case ConnectionStatus.playersscreen:
        return const PlayersScreen();
      default:
        return const SetupScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: Scaffold(
        body: _setLayout(context),
      ),
    );
  }
}

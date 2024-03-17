import 'package:flame/game.dart';
import 'package:flappy_ember/game.dart';
import 'package:flutter/material.dart';

enum ConnectionStatus {
  setupscreen,
  playersscreen,
}

class AppData with ChangeNotifier {
  List<dynamic> connectedPlayers = [];
  List<dynamic> lostPlayers = [];
  String namePlayer = "";
  bool partida = false;
  ConnectionStatus connectionStatus = ConnectionStatus.setupscreen;
  int tiempo = 30;

  void forceNotifyListeners() {
    super.notifyListeners();
  }

  void setUsuarios(List<dynamic> value) {
    connectedPlayers = value;
    notifyListeners();
  }

  void setUsuarioslost(List<dynamic> value) {
    lostPlayers = value;
    notifyListeners();
  }

  void setTiempo(int value) {
    tiempo = value;
    notifyListeners();
  }

  void setNamePlayer(String value) {
    namePlayer = value;
    notifyListeners();
  }

  String getNamePlayer() {
    return namePlayer;
  }
}

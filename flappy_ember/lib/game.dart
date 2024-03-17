// Importaciones necesarias
import 'dart:convert';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/src/components/core/component.dart';
import 'package:flappy_ember/appdata.dart';
import 'package:flappy_ember/box_stack.dart';
import 'package:flappy_ember/ground.dart';
import 'package:flappy_ember/opponent.dart';
import 'package:flappy_ember/player.dart';
import 'package:flappy_ember/ranking.dart';
import 'package:flappy_ember/sky.dart';
import 'package:flappy_ember/websockets_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlappyEmberGame extends FlameGame
    with HasCollisionDetection, TapDetector {
  Function? onGameStart;
  FlappyEmberGame() {
    _initializeWebSocket();
  }

  late final WebSocketsHandler _webSocketsHandler;
  double speed = 200;
  late final Player _player = Player();
  double _timeSinceBox = 0;
  double _boxInterval = 1;
  double _timeSinceLastUpdate = 0;
  final double updateInterval = 0.5;
  List<dynamic> connectedPlayers = [];
  List<dynamic> lostPlayers = [];
  Map<String, Opponent> opponents = {};
  Function(List<dynamic> connectedPlayers)? onPlayersUpdated;
  Function(List<dynamic> lostPlayers)? onPlayersUpdatedlost;
  Function(int tiempo)? onTiempo;
  late String name;
  int tiempo = 30;

  @override
  Future<void> onLoad() async {
    add(_player);
    add(Sky());
    add(Ground());
    add(ScreenHitbox());
  }

  @override
  void onTap() {
    _player.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceBox += dt;
    if (_timeSinceBox > _boxInterval) {
      add(BoxStack());
      _timeSinceBox = 0;
    }
    if (_player.perdido == false) {
      _timeSinceLastUpdate += dt;
      if (_timeSinceLastUpdate >= updateInterval) {
        _sendPlayerPosition();
        _timeSinceLastUpdate = 0;
      }
    } else {
      _sendPlayerLose();
      connectedPlayers.removeWhere(
          (player) => player['id'] == _webSocketsHandler.mySocketId);
    }
  }

  void _initializeWebSocket() {
    _webSocketsHandler = WebSocketsHandler();
    _webSocketsHandler.connectToServer("localhost", 8888, _onMessageReceived);
  }

  void _onMessageReceived(String message) {
    final data = jsonDecode(message);

    switch (data['type']) {
      case 'welcome':
        _webSocketsHandler.sendMessage(jsonEncode({
          'type': 'init',
          'name': name,
        }));
        print("Welcome: ${data['value']}");
        String assignedColorHex = data['color'] as String;
        Color assignedColor;
        if (RegExp(r'^#([0-9A-Fa-f]{6})$').hasMatch(assignedColorHex)) {
          // Es un valor hexadecimal, convertirlo a un Color
          assignedColor =
              Color(int.parse(assignedColorHex.replaceFirst('#', '0xff')));
        } else {
          // No es un valor hexadecimal, buscar en un mapeo de nombres de colores conocidos
          assignedColor = _colorFromName(assignedColorHex) ??
              Colors.black; // Usar negro como color por defecto
        }
        // Cambiar el color del jugador
        _player.changeColor(assignedColor);
        _webSocketsHandler.mySocketId = data['id'].toString();
        break;
      case 'data':
        List<dynamic> opponentsData = data['opponents'] as List<dynamic>;
        for (var oppData in opponentsData) {
          final id = oppData['id'];

          if (id == _webSocketsHandler.mySocketId) continue;
          if (opponents.containsKey(id)) {
            final opponent = opponents[id]!;
            double? clientX = -100.0;
            double? clientY = -100.0;
            var x = oppData['x'];
            if (x != null) {
              clientX =
                  (x is num) ? x.toDouble() : double.tryParse(x.toString());
            }
            var y = oppData['y'];
            if (y != null) {
              clientY =
                  (y is num) ? y.toDouble() : double.tryParse(y.toString());
            }
            opponent.position = Vector2(clientX!, clientY!);
          }
        }
        break;
      case 'playerListUpdate':
        connectedPlayers = (data['connectedPlayers'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        onPlayersUpdated?.call(connectedPlayers);

        print("Updated Players List: $connectedPlayers");
        for (var playerData in connectedPlayers) {
          final id = playerData['id'].toString();
          if (id == _webSocketsHandler.mySocketId) continue;
          final colorName = playerData['color'] as String;
          final color = _colorFromName(colorName) ?? Colors.grey;

          if (!opponents.containsKey(id)) {
            final newOpponent = Opponent(id: id, color: color)
              ..position = Vector2(0, 0);
            opponents[id] = newOpponent;
            add(newOpponent);
          } else {
            final existingOpponent = opponents[id]!;
            existingOpponent.color = color;
          }
        }
        opponents.keys
            .where(
                (id) => !connectedPlayers.any((p) => p['id'].toString() == id))
            .toList()
            .forEach((id) {
          opponents.remove(id);
        });

        break;
      case "gameStart":
        onGameStart?.call();
        break;

      case "playerLostUpdate":
        lostPlayers = (data['lost'] as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        onPlayersUpdatedlost?.call(lostPlayers);
      for (var lostPlayerData in lostPlayers) {
        final lostPlayerId = lostPlayerData['id'].toString();
        if (opponents.containsKey(lostPlayerId)) {
          final opponentToRemove = opponents.remove(lostPlayerId);
          remove(opponentToRemove!);
        }
      }
        break;

      case "countdown":
        tiempo = data['value'] as int;
        onTiempo?.call(tiempo);
        break;
    }
  }

  Color? _colorFromName(String name) {
    switch (name) {
      case 'vermell':
        return Colors.red;
      case 'verd':
        return Colors.green;
      case 'taronja':
        return Colors.orange;
      case 'blau':
        return Colors.blue;
      default:
        return null;
    }
  }

  void _sendPlayerPosition() {
    _webSocketsHandler.sendMessage(jsonEncode({
      'type': 'move',
      'x': _player.x,
      'y': _player.y,
    }));
  }

  void _sendPlayerLose() {
    _webSocketsHandler.sendMessage(jsonEncode({
      'type': 'perdido',
      'id': _webSocketsHandler.mySocketId,
      'name': name
    }));
  }

  void disconnect() {
    _webSocketsHandler.disconnectFromServer();
  }

  @override
  void onRemove() {
    super.onRemove();
    print("Player ha sido eliminado.");
  }
}

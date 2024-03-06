// Importaciones necesarias
import 'dart:convert';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flappy_ember/box_stack.dart';
import 'package:flappy_ember/ground.dart';
import 'package:flappy_ember/player.dart';
import 'package:flappy_ember/sky.dart';
import 'package:flappy_ember/websockets_handler.dart';

class FlappyEmberGame extends FlameGame with HasCollisionDetection, TapDetector {
  final String playerName;
  FlappyEmberGame({required this.playerName}) {
    _initializeWebSocket();
  }

  

  late final WebSocketsHandler _webSocketsHandler;
  double speed = 200;
  late final Player _player;
  double _timeSinceBox = 0;
  double _boxInterval = 1;
  double _timeSinceLastUpdate = 0; // Nuevo
  final double updateInterval = 0.5; // Nuevo, ajusta según necesites
  List<dynamic> connectedPlayers = [];

  @override
  Future<void> onLoad() async {
    add(_player = Player());
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

    // Envía la posición del jugador al servidor cada updateInterval segundos
    _timeSinceLastUpdate += dt;
    if (_timeSinceLastUpdate >= updateInterval) {
      _sendPlayerPosition();
      _timeSinceLastUpdate = 0;
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
      'name': playerName,
    }));
      print("Welcome: ${data['value']}");
      // Suponiendo que el servidor envía el color asignado en la propiedad 'color'
      String assignedColor = data['color'].toString();
      print("Assigned Color: $assignedColor");
      // Aquí podrías establecer el color del jugador o cualquier otra lógica relacionada.
      break;
    case 'data':
      // Actualizar el estado del juego con los datos recibidos
      break;
    case 'playerListUpdate':
      connectedPlayers = (data['connectedPlayers'] as List).map((e) => e as dynamic).toList();
      // Aquí podrías actualizar la UI o el estado de la app con la nueva lista de jugadores
      print("Updated Players List: $connectedPlayers");
      // Por ejemplo, podrías enviar esta lista a una pantalla o widget que muestre los jugadores conectados
      break;
    // Añade más casos según necesites
  }
}


  // Nuevo: Método para enviar la posición del jugador al servidor
  void _sendPlayerPosition() {
    _webSocketsHandler.sendMessage(jsonEncode({
      'type': 'move',
      'x': _player.x,
      'y': _player.y,
    }));
  }

  @override
  void onRemove() {
    _webSocketsHandler.disconnectFromServer();
    super.onRemove();
  }
}

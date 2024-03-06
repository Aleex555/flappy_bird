import 'package:flappy_ember/appdata.dart';
import 'package:flappy_ember/players_screen.dart';
import 'package:flutter/material.dart';
import 'package:flappy_ember/game.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _startGame() async {
    final ip = _ipController.text;
    final port =
        int.tryParse(_portController.text) ?? 8888; // Puerto por defecto 8888
    final name = _nameController.text;
    // En algún lugar dentro de un widget, donde tengas acceso a context
    final appData = Provider.of<AppData>(context, listen: false);
    final game = FlappyEmberGame(playerName: name, appData: appData);

    // Espera de forma artificial, en práctica deberías esperar de manera más adecuada
    await Future.delayed(Duration(seconds: 2));

    // Asumiendo que game.connectedPlayers ahora está lleno
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PlayersScreen(
        game: game,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración del Juego'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: InputDecoration(labelText: 'IP del Servidor'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _portController,
              decoration: InputDecoration(labelText: 'Puerto'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre del Jugador'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startGame,
              child: Text('Comenzar Juego'),
            ),
          ],
        ),
      ),
    );
  }
}

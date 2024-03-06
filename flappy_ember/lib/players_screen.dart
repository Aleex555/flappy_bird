import 'package:flappy_ember/appdata.dart';
import 'package:flappy_ember/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Asegúrate de importar todas las dependencias necesarias...

class PlayersScreen extends StatefulWidget {
  final FlappyEmberGame game;

  PlayersScreen({required this.game});

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Consumer<AppData>(
              builder: (context, appData, child) {
                return ListView.builder(
                  itemCount: appData.connectedPlayers.length,
                  itemBuilder: (context, index) {
                    var playerName =
                        appData.connectedPlayers[index]['name'] as String;
                    return Center(
                      child: ListTile(
                        title: Text(playerName, textAlign: TextAlign.center),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.exit_to_app),
              label: Text('Desconectar'),
              onPressed: () {
                widget.game.disconnect();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors
                    .red, // Define el color del botón aquí si lo necesitas
                minimumSize: Size(
                    double.infinity, 50), // Toma el ancho completo disponible
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flame/game.dart';
import 'package:flappy_ember/appdata.dart';
import 'package:flappy_ember/game.dart'; // Asegúrate de que este importe apunta a tu juego correctamente
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.exit_to_app),
              label: Text('Desconectar'),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

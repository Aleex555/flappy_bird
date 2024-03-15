import 'package:flame/game.dart';
import 'package:flappy_ember/appdata.dart';
import 'package:flappy_ember/game.dart';
import 'package:flappy_ember/ranking.dart';
import 'package:flappy_ember/setupscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayersScreen extends StatefulWidget {
  final FlappyEmberGame game;

  const PlayersScreen({super.key, required this.game});

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  void initState() {
    super.initState();
    widget.game.onPlayersUpdated = _updateConnectedPlayers;
    widget.game.onGameStart = () {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => GameWidget(
        game: widget.game,
        overlayBuilderMap: {
          'rankingOverlay': (context, _) => RankingScreen(game: widget.game),
        },
      ),
    ),
  );
};

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Sala de espera',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: const [
                Expanded(
                  flex: 2, // Ajusta la proporción según sea necesario
                  child: Text('Nombre',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Expanded(
                  child: Text('Color',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<AppData>(
              builder: (context, appData, child) {
                return ListView.builder(
                  itemCount: appData.connectedPlayers.length,
                  itemBuilder: (context, index) {
                    var playerName =
                        appData.connectedPlayers[index]['name'] as String;
                    var playerColor =
                        appData.connectedPlayers[index]['color'] as String;
                    Color? color = _colorFromName(
                        playerColor); // Convierte el String a Color.
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2, // Ajusta la proporción según sea necesario
                            child: Text(playerName,
                                style: TextStyle(fontSize: 18)),
                          ),
                          Expanded(
                            child: Container(
                              width: 30,
                              height: 30,
                              color: color,
                            ),
                          ),
                        ],
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
                widget.game.disconnect();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SetupScreen()),
                );
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

  void _updateConnectedPlayers(List<dynamic> connectedPlayers) {
  if (mounted) {
    Provider.of<AppData>(context, listen: false).setUsuarios(connectedPlayers);
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
}

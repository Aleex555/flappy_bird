import 'package:flappy_ember/appdata.dart';
import 'package:flappy_ember/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingScreen extends StatefulWidget {
  final FlappyEmberGame game;

  const RankingScreen({Key? key, required this.game}) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  void initState() {
    super.initState();
    widget.game.onPlayersUpdatedlost = _updateLostPlayers;
  }

  @override
  Widget build(BuildContext context) {
    // Aquí obtenemos la lista de jugadores perdidos desde AppData
    List<Map<String, dynamic>> playersList =
        Provider.of<AppData>(context).lostPlayers;

    return Scaffold(
      body: ListView.separated(
        itemCount: playersList.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey),
        itemBuilder: (BuildContext context, int index) {
          final player = playersList[index];
          return _buildPlayerTile(player, index);
        },
      ),
    );
  }

  ListTile _buildPlayerTile(Map<String, dynamic> player, int index) {
    Color? tileColor;
    IconData? leadingIcon;

    // Configura el color y el icono basado en la posición
    switch (player['position']) {
      case 1:
        tileColor = gold;
        leadingIcon = Icons.emoji_events;
        break;
      case 2:
        tileColor = silver;
        leadingIcon = Icons.emoji_events;
        break;
      case 3:
        tileColor = bronze;
        leadingIcon = Icons.emoji_events;
        break;
      default:
        tileColor = Colors.white;
        leadingIcon = Icons.person;
    }

    return ListTile(
      tileColor: tileColor,
      leading: Icon(
        leadingIcon,
        color: Colors.black54,
      ),
      title: Text(
        'Jugador ${player['id']}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Posición: ${player['position']}'),
      trailing: index < 3 ? Icon(Icons.star, color: Colors.yellow) : null,
    );
  }

  void _updateLostPlayers(List<dynamic> lostPlayers) {
    Provider.of<AppData>(context, listen: false).setUsuarioslost(lostPlayers);
  }
}

const Color gold = Color(0xFFFFD700);
const Color silver = Color(0xFFC0C0C0);
const Color bronze = Color(0xFFCD7F32);

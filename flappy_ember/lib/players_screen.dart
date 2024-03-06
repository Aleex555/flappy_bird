import 'package:flutter/material.dart';

// Cambiamos StatelessWidget por StatefulWidget
class PlayersScreen extends StatefulWidget {
  final List<dynamic> connectedPlayers;

  PlayersScreen({Key? key, required this.connectedPlayers}) : super(key: key);

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jugadores Conectados'),
      ),
      body: ListView.builder(
        itemCount: widget.connectedPlayers.length, // Acceso con widget.connectedPlayers
        itemBuilder: (context, index) {
          // Aseguramos el casting a String para evitar errores
          var playerName = widget.connectedPlayers[index]['name'] as String;
          return ListTile(
            title: Text(playerName),
          );
        },
      ),
    );
  }
}

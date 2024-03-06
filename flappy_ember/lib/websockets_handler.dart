import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

enum ConnectionStatus {
  disconnected,
  disconnecting,
  connecting,
  connected,
}

class WebSocketsHandler {
  late Function _callback;
  String ip = "localhost";
  String port = "8888";

  IOWebSocketChannel? _socketClient;
  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;

  String? mySocketId;

  void connectToServer(String serverIp, int serverPort,
      void Function(String message) callback) async {
    // Set connection settings
    _callback = callback;
    ip = serverIp;
    port = serverPort.toString();

    // Connect to server
    connectionStatus = ConnectionStatus.connecting;

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 1));

    _socketClient = IOWebSocketChannel.connect("ws://$ip:$port");
    _socketClient!.stream.listen(
      (message) {
        if (connectionStatus != ConnectionStatus.connected) {
          connectionStatus = ConnectionStatus.connected;
        }
        _callback(message);
      },
      onError: (error) {
        connectionStatus = ConnectionStatus.disconnected;
        mySocketId = "";
        if (kDebugMode) {
          print("Error WebSocketHandler: $error\n");
        }
      },
      onDone: () {
        connectionStatus = ConnectionStatus.disconnected;
        mySocketId = "";
        if (kDebugMode) {
          print("Done WebSocketHandler\n");
        }
      },
    );
  }

  void sendMessage(String message) {
    if (connectionStatus != ConnectionStatus.connected) {
      return;
    }
    if (kDebugMode) {
      // print("Sending message: $message");
    }
    _socketClient!.sink.add(message);
  }

  disconnectFromServer() async {
    connectionStatus = ConnectionStatus.disconnecting;

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 1));

    _socketClient!.sink.close();
  }
}

import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  // Access appData globaly with:
  // AppData appData = Provider.of<AppData>(context);
  // AppData appData = Provider.of<AppData>(context, listen: false)

  List<dynamic> connectedPlayers = [];
  void forceNotifyListeners() {
    super.notifyListeners();
  }

  void setUsuarios(List<dynamic> value) {
    connectedPlayers = value;
    notifyListeners();
  }
}

// Erstelle eine Klasse, um den Anmeldestatus zu repräsentieren
import 'package:flutter/material.dart';

class SessionState extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

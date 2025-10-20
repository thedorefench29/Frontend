import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _userName;
  bool _isLoggedIn = false;

  String? get userName => _userName;
  bool get isLoggedIn => _isLoggedIn;

  void login(String name) {
    _userName = name;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _userName = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}


import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void signIn(String email, String password) {
    // Implementasi logika sign in
    _isAuthenticated = true;
    notifyListeners();
  }

  void signUp(String email, String password) {
    // Implementasi logika sign up
    _isAuthenticated = true;
    notifyListeners();
  }

  void signOut() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

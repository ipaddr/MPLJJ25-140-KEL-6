import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  Future<void> signIn(String email, String password) async {
    try {
      // Simulasi delay login
      await Future.delayed(const Duration(seconds: 1));

      // Implementasi logika sign-in, misalnya validasi email dan password
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Email and password cannot be empty");
      }

      // Simulasikan login berhasil
      _isAuthenticated = true;
      _errorMessage = null; // Reset error message jika login berhasil
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString(); // Menyimpan pesan error
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      // Simulasi delay sign up
      await Future.delayed(const Duration(seconds: 1));

      // Implementasi logika sign-up
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Email and password cannot be empty");
      }

      // Simulasikan sign-up berhasil
      _isAuthenticated = true;
      _errorMessage = null; // Reset error message jika sign up berhasil
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString(); // Menyimpan pesan error
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    // Simulasi sign-out
    await Future.delayed(const Duration(seconds: 1));

    _isAuthenticated = false;
    _errorMessage = null; // Reset error message saat sign-out
    notifyListeners();
  }
}

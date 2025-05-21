import 'package:flutter/material.dart';
import 'package:projectakhirmobileprogramming/models/user.dart'; // Assuming you have user and admin models
import 'package:projectakhirmobileprogramming/models/admin.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  User? _currentUser; // Placeholder for authenticated user
  Admin? _currentAdmin; // Placeholder for authenticated admin

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  Admin? get currentAdmin => _currentAdmin;

  bool get isAuthenticated {
    // Simple check if either a user or admin is authenticated
    return _currentUser != null || _currentAdmin != null;
  }

  // Placeholder method for user login
  Future<void> loginUser(String username, String password) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

 print('Attempting user login...');
    try {
      // TODO: Implement Firebase User Login logic here
      // For now, simulate a delay and success
      await Future.delayed(const Duration(seconds: 2));
      _currentUser = User(
          uid: 'user123',
          email: 'user@example.com', nik: '1234567890123456',
          username: 'testuser'); // Simulate a logged-in user

 print('User login successful (simulated).');
      _isLoading = false;
 _errorMessage = null; // Clear any previous error
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString(); // Use actual error message
      _currentUser = null;
      notifyListeners();
 print('User login failed: $_errorMessage');
    }
  }

  // Placeholder method for user registration
  Future<void> registerUser({
    required String nik,
    required String fullName,
    required String phoneNumber,
    required String email,
    required String username,
    required String password,
    // TODO: Add parameters for photos
  }) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

 print('Attempting user registration...');
    try {
      // TODO: Implement Firebase User Registration logic here
      // For now, simulate a delay and success
 print('Placeholder: User registration logic goes here.');
      await Future.delayed(const Duration(seconds: 2));
      // _currentUser = User(...); // Simulate a newly registered and logged-in user

      _isLoading = false;
      notifyListeners();
      // Optionally navigate to login screen after successful registration
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString(); // Use actual error message
      notifyListeners();
 print('User registration failed: $_errorMessage');
    }
  }

  // Placeholder method for admin login
  Future<void> loginAdmin(String username, String password) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

 print('Attempting admin login...');
    try {
      // TODO: Implement Firebase Admin Login logic here
      // For now, simulate a delay and success
 print('Placeholder: Admin login logic goes here.');
      await Future.delayed(const Duration(seconds: 2));
      _currentAdmin = Admin(
          uid: 'admin123',
 email: 'admin@example.com', nip: '12345'); // Simulate a logged-in admin

 print('Admin login successful (simulated).');
      _isLoading = false;
 _errorMessage = null; // Clear any previous error
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString(); // Use actual error message
      _currentAdmin = null;
      notifyListeners();
    }
 print('Admin login failed: $_errorMessage');
  }

  // Placeholder method for admin registration
  Future<void> registerAdmin({
    required String nip,
    required String fullName,
    required String phoneNumber,
    required String email,
    required String statusKepegawaian,
    required int tahunDiangkat,
    required String wilayahPenempatan,
    required String golongan,
    required String password,
  }) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

 print('Attempting admin registration...');
    try {
      // TODO: Implement Firebase Admin Registration logic here
      // For now, simulate a delay and success
 print('Placeholder: Admin registration logic goes here.');
      await Future.delayed(const Duration(seconds: 2));
      // _currentAdmin = Admin(...); // Simulate a newly registered and logged-in admin

      _isLoading = false;
      notifyListeners();
      // Optionally navigate to admin login screen after successful registration
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString(); // Use actual error message
      notifyListeners();
 print('Admin registration failed: $_errorMessage');
    }
  }

  // Placeholder method for logging out
  Future<void> logout() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

 print('Attempting logout...');
    try {
      // TODO: Implement Firebase Logout logic here
 print('Placeholder: Logout logic goes here.');
      await Future.delayed(const Duration(seconds: 1)); // Simulate delay
      _currentUser = null;
      _currentAdmin = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = e.toString(); // Use actual error message
      notifyListeners();
 print('Logout failed: $_errorMessage');
    }
  }
}

// Placeholder User Model (create this file in projectakhirmobileprogramming/lib/models/user.dart)
// class User {
//   final String uid;
//   final String email;
//   final String username; // Or NIK if using NIK for user login
//   final String nik;
//   // Add other user fields as needed

//   User({required this.uid, required this.email, required this.username});
// }

// Placeholder Admin Model (create this file in projectakhirmobileprogramming/lib/models/admin.dart)
// class Admin {
//   final String uid;
//   final String email;
//   final String nip;
//   final String fullName;
//   // Add other admin fields as needed

//   Admin({required this.uid, required this.email, required this.nip, required this.fullName});
// }
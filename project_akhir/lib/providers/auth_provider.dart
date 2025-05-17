import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:project_akhir/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  User? _firebaseUser;
  UserModel? _userModel;
  AdminModel? _adminModel;
  bool _isLoading = false;
  String? _errorMessage;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  AdminModel? get adminModel => _adminModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;
  bool get isAdmin => _adminModel != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _setLoading(true);

    _auth.authStateChanges().listen((User? user) async {
      _firebaseUser = user;

      if (user != null) {
        try {
          await _fetchUserData();
        } catch (e) {
          // Tangani error agar tidak stuck loading
          _userModel = null;
          _adminModel = null;
          _setError('Failed to fetch user data.');
        }
      } else {
        _userModel = null;
        _adminModel = null;
      }

      _setLoading(false);
      notifyListeners();
    });
  }

  Future<void> _fetchUserData() async {
    if (_firebaseUser == null) return;

    final docSnapshot = await _firestore
        .collection('users')
        .doc(_firebaseUser!.uid)
        .get();

    if (!docSnapshot.exists) {
      _userModel = null;
      _adminModel = null;
      return;
    }

    final userData = docSnapshot.data()!;

    // Pastikan isAdmin bisa ada dan adalah bool, jika tidak default false
    final isAdmin = userData['isAdmin'] == true;

    if (isAdmin) {
      _adminModel = AdminModel.fromMap(userData);
      _userModel = null;
    } else {
      _userModel = UserModel.fromMap(userData);
      _adminModel = null;
    }
  }

  Future<bool> registerUser({
    required String email,
    required String password,
    required String name,
    required String nik,
    required String phoneNumber,
    File? profileImage,
    File? ktpImage,
    required String username,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? profileImageUrl;
      String? ktpImageUrl;

      if (profileImage != null) {
        profileImageUrl = await _uploadFile(
          profileImage,
          'users/${userCredential.user!.uid}/profile.jpg',
        );
      }

      if (ktpImage != null) {
        ktpImageUrl = await _uploadFile(
          ktpImage,
          'users/${userCredential.user!.uid}/ktp.jpg',
        );
      }

      final user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        nik: nik,
        profileImageUrl: profileImageUrl,
        additionalInfo: {
          'username': username,
          'ktpImageUrl': ktpImageUrl,
          'isAdmin': false,  // Penting: tambahkan flag ini supaya jelas bukan admin
        },
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());

      await _fetchUserData();
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerAdmin({
    required String email,
    required String password,
    required String name,
    required String nip,
    required String phoneNumber,
    required String employmentStatus,
    required String appointmentYear,
    required String placementArea,
    required String grade,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final admin = AdminModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        nik: nip, // menggunakan nip sebagai nik
        nip: nip,
        employmentStatus: employmentStatus,
        appointmentYear: appointmentYear,
        placementArea: placementArea,
        grade: grade,
        isAdmin: true,  // Tambahkan flag admin supaya jelas
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(admin.toMap());

      await _fetchUserData();
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Setelah login, authStateChanges listener akan otomatis update data user
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _auth.signOut();
      _userModel = null;
      _adminModel = null;
    } catch (e) {
      _setError(e.toString());
    }
    _setLoading(false);
  }

  Future<bool> updateUserProfile({
    String? name,
    String? phoneNumber,
    File? profileImage,
    File? coverImage,
    String? gender,
    Map<String, dynamic>? additionalInfo,
  }) async {
    if (_firebaseUser == null) return false;
    
    _setLoading(true);
    _clearError();

    try {
      final Map<String, dynamic> updateData = {};
      
      if (name != null) updateData['name'] = name;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (gender != null) updateData['gender'] = gender;
      
      if (profileImage != null) {
        final profileImageUrl = await _uploadFile(
          profileImage,
          'users/${_firebaseUser!.uid}/profile.jpg',
        );
        updateData['profileImageUrl'] = profileImageUrl;
      }
      
      if (coverImage != null) {
        final coverImageUrl = await _uploadFile(
          coverImage,
          'users/${_firebaseUser!.uid}/cover.jpg',
        );
        updateData['coverImageUrl'] = coverImageUrl;
      }

      if (additionalInfo != null) {
        final currentAdditionalInfo = _userModel?.additionalInfo ?? {};
        currentAdditionalInfo.addAll(additionalInfo);
        updateData['additionalInfo'] = currentAdditionalInfo;
      }

      await _firestore
          .collection('users')
          .doc(_firebaseUser!.uid)
          .update(updateData);

      await _fetchUserData();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<String> _uploadFile(File file, String path) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  void _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        _setError('No user found for that email.');
        break;
      case 'wrong-password':
        _setError('Wrong password provided.');
        break;
      case 'email-already-in-use':
        _setError('The email address is already in use.');
        break;
      case 'invalid-email':
        _setError('The email address is invalid.');
        break;
      case 'weak-password':
        _setError('The password is too weak.');
        break;
      default:
        _setError(e.message ?? 'An error occurred');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    // Jangan panggil notifyListeners di sini untuk menghindari rebuild berlebih
  }
}

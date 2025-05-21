import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rumahku/models/admin_model.dart';
import 'package:rumahku/models/user_model.dart';
import 'package:rumahku/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum UserType { user, admin, none }

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _firebaseUser;
  UserModel? _user;
  AdminModel? _admin;
  UserType _userType = UserType.none;
  bool _isLoading = false;

  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _user;
  AdminModel? get admin => _admin;
  UserType get userType => _userType;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((user) async {
      _firebaseUser = user;
      if (user != null) {
        await _loadUserData();
      } else {
        _user = null;
        _admin = null;
        _userType = UserType.none;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData() async {
    _setLoading(true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUserType = prefs.getString('userType');
      
      if (storedUserType == 'admin') {
        await _loadAdminData();
      } else {
        await _loadRegularUserData();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadRegularUserData() async {
    final userDoc = await _firestore.collection(AppConstants.usersCollection).doc(_firebaseUser!.uid).get();
    
    if (userDoc.exists) {
      _user = UserModel.fromMap(userDoc.data()!, _firebaseUser!.uid);
      _userType = UserType.user;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'user');
    } else {
      // Try loading as admin if not found as regular user
      await _loadAdminData();
    }
  }

  Future<void> _loadAdminData() async {
    final adminDoc = await _firestore.collection(AppConstants.adminsCollection).doc(_firebaseUser!.uid).get();
    
    if (adminDoc.exists) {
      _admin = AdminModel.fromMap(adminDoc.data()!, _firebaseUser!.uid);
      _userType = UserType.admin;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'admin');
    } else {
      // Reset if not found as either user or admin
      _user = null;
      _admin = null;
      _userType = UserType.none;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userType');
    }
  }

  Future<String> _uploadImage(Uint8List imageData, String path) async {
    final uuid = const Uuid().v4();
    final ref = _storage.ref().child('$path/$uuid.jpg');
    await ref.putData(imageData);
    return await ref.getDownloadURL();
  }

  Future<bool> registerUser({
    required String nik,
    required String fullName,
    required String phoneNumber,
    required String email,
    required String username,
    required String password,
    Uint8List? ktpImage,
    Uint8List? selfieImage,
  }) async {
    _setLoading(true);
    try {
      // Create user with email and password
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Upload images if provided
      String? ktpImageUrl;
      String? selfieImageUrl;
      
      if (ktpImage != null) {
        ktpImageUrl = await _uploadImage(ktpImage, AppConstants.userKtpImagesPath);
      }
      
      if (selfieImage != null) {
        selfieImageUrl = await _uploadImage(selfieImage, AppConstants.userSelfieImagesPath);
      }
      
      // Create user document
      final userData = UserModel(
        id: credential.user!.uid,
        nik: nik,
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        username: username,
        ktpImageUrl: ktpImageUrl,
        selfieImageUrl: selfieImageUrl,
      );
      
      await _firestore.collection(AppConstants.usersCollection).doc(credential.user!.uid).set(userData.toMap());
      
      // Set user type in preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'user');
      
      // Load user data
      _user = userData;
      _userType = UserType.user;
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error registering user: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> registerAdmin({
    required String nip,
    required String fullName,
    required String phoneNumber,
    required String email,
    required String employmentStatus,
    required String appointmentYear,
    required String placementArea,
    required String rank,
    required String password,
  }) async {
    _setLoading(true);
    try {
      // Create user with email and password
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create admin document
      final adminData = AdminModel(
        id: credential.user!.uid,
        nip: nip,
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        employmentStatus: employmentStatus,
        appointmentYear: appointmentYear,
        placementArea: placementArea,
        rank: rank,
      );
      
      await _firestore.collection(AppConstants.adminsCollection).doc(credential.user!.uid).set(adminData.toMap());
      
      // Set user type in preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'admin');
      
      // Load admin data
      _admin = adminData;
      _userType = UserType.admin;
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error registering admin: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
    required UserType userType,
  }) async {
    _setLoading(true);
    try {
      // Sign in user
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Check if the user exists in the correct collection
      if (userType == UserType.user) {
        final userDoc = await _firestore.collection(AppConstants.usersCollection).doc(credential.user!.uid).get();
        if (!userDoc.exists) {
          await _auth.signOut();
          return false;
        }
        
        _user = UserModel.fromMap(userDoc.data()!, credential.user!.uid);
        _userType = UserType.user;
        
        // Set user type in preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userType', 'user');
      } else if (userType == UserType.admin) {
        final adminDoc = await _firestore.collection(AppConstants.adminsCollection).doc(credential.user!.uid).get();
        if (!adminDoc.exists) {
          await _auth.signOut();
          return false;
        }
        
        _admin = AdminModel.fromMap(adminDoc.data()!, credential.user!.uid);
        _userType = UserType.admin;
        
        // Set user type in preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userType', 'admin');
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error logging in: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateUserProfile({
    String? fullName,
    String? phoneNumber,
    String? gender,
    int? familyMembers,
    String? residenceStatus,
    String? ownershipYear,
    String? ownershipStatus,
    String? waterStatus,
    String? humidityStatus,
    String? environmentStatus,
    Uint8List? profileImage,
    Uint8List? coverImage,
  }) async {
    if (_user == null) return false;
    
    _setLoading(true);
    try {
      final Map<String, dynamic> updates = {};
      
      if (fullName != null) updates['fullName'] = fullName;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (gender != null) updates['gender'] = gender;
      if (familyMembers != null) updates['familyMembers'] = familyMembers;
      if (residenceStatus != null) updates['residenceStatus'] = residenceStatus;
      if (ownershipYear != null) updates['ownershipYear'] = ownershipYear;
      if (ownershipStatus != null) updates['ownershipStatus'] = ownershipStatus;
      if (waterStatus != null) updates['waterStatus'] = waterStatus;
      if (humidityStatus != null) updates['humidityStatus'] = humidityStatus;
      if (environmentStatus != null) updates['environmentStatus'] = environmentStatus;
      
      // Upload profile image if provided
      if (profileImage != null) {
        final profileImageUrl = await _uploadImage(profileImage, AppConstants.userProfileImagesPath);
        updates['profileImageUrl'] = profileImageUrl;
      }
      
      // Upload cover image if provided
      if (coverImage != null) {
        final coverImageUrl = await _uploadImage(coverImage, AppConstants.userCoverImagesPath);
        updates['coverImageUrl'] = coverImageUrl;
      }
      
      await _firestore.collection(AppConstants.usersCollection).doc(_user!.id).update(updates);
      
      // Update local user model
      _user = _user!.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber,
        gender: gender,
        familyMembers: familyMembers,
        residenceStatus: residenceStatus,
        ownershipYear: ownershipYear,
        ownershipStatus: ownershipStatus,
        waterStatus: waterStatus,
        humidityStatus: humidityStatus,
        environmentStatus: environmentStatus,
        profileImageUrl: profileImage != null ? updates['profileImageUrl'] : _user!.profileImageUrl,
        coverImageUrl: coverImage != null ? updates['coverImageUrl'] : _user!.coverImageUrl,
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateAdminProfile({
    String? fullName,
    String? phoneNumber,
    String? gender,
    String? employmentStatus,
    String? appointmentYear,
    String? placementArea,
    String? rank,
    Uint8List? profileImage,
    Uint8List? coverImage,
  }) async {
    if (_admin == null) return false;
    
    _setLoading(true);
    try {
      final Map<String, dynamic> updates = {};
      
      if (fullName != null) updates['fullName'] = fullName;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (gender != null) updates['gender'] = gender;
      if (employmentStatus != null) updates['employmentStatus'] = employmentStatus;
      if (appointmentYear != null) updates['appointmentYear'] = appointmentYear;
      if (placementArea != null) updates['placementArea'] = placementArea;
      if (rank != null) updates['rank'] = rank;
      
      // Upload profile image if provided
      if (profileImage != null) {
        final profileImageUrl = await _uploadImage(profileImage, AppConstants.adminProfileImagesPath);
        updates['profileImageUrl'] = profileImageUrl;
      }
      
      // Upload cover image if provided
      if (coverImage != null) {
        final coverImageUrl = await _uploadImage(coverImage, AppConstants.adminCoverImagesPath);
        updates['coverImageUrl'] = coverImageUrl;
      }
      
      await _firestore.collection(AppConstants.adminsCollection).doc(_admin!.id).update(updates);
      
      // Update local admin model
      _admin = _admin!.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber,
        gender: gender,
        employmentStatus: employmentStatus,
        appointmentYear: appointmentYear,
        placementArea: placementArea,
        rank: rank,
        profileImageUrl: profileImage != null ? updates['profileImageUrl'] : _admin!.profileImageUrl,
        coverImageUrl: coverImage != null ? updates['coverImageUrl'] : _admin!.coverImageUrl,
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating admin profile: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _auth.signOut();
      
      _user = null;
      _admin = null;
      _userType = UserType.none;
      
      // Clear user type in preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userType');
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging out: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
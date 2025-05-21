import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rumahku/models/request_model.dart';
import 'package:rumahku/utils/constants.dart';
import 'package:uuid/uuid.dart';

class RequestProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<RequestModel> _requests = [];
  List<RequestModel> _approvedRequests = [];
  RequestModel? _currentRequest;
  bool _isLoading = false;
  String? _error;

  // Form data for multi-step request
  Map<String, dynamic> _requestFormData = {};
  int _currentStep = 0;

  List<RequestModel> get requests => _requests;
  List<RequestModel> get approvedRequests => _approvedRequests;
  RequestModel? get currentRequest => _currentRequest;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic> get requestFormData => _requestFormData;
  int get currentStep => _currentStep;

  Future<void> fetchUserRequests() async {
    if (_auth.currentUser == null) return;

    _setLoading(true);
    _error = null;
    try {
      final snapshot = await _firestore.collection(AppConstants.requestsCollection)
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .orderBy('submissionDate', descending: true)
          .get();

      _requests = snapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      _error = 'Failed to load requests: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllRequests() async {
    _setLoading(true);
    _error = null;
    try {
      // Fetch pending requests
      final pendingSnapshot = await _firestore.collection(AppConstants.requestsCollection)
          .where('status', isEqualTo: 'pending')
          .orderBy('submissionDate', descending: true)
          .get();

      _requests = pendingSnapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data(), doc.id))
          .toList();

      // Fetch approved requests
      final approvedSnapshot = await _firestore.collection(AppConstants.requestsCollection)
          .where('status', isEqualTo: 'approved')
          .orderBy('submissionDate', descending: true)
          .get();

      _approvedRequests = approvedSnapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      _error = 'Failed to load requests: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getRequestById(String id) async {
    _setLoading(true);
    _error = null;
    try {
      final docSnapshot = await _firestore.collection(AppConstants.requestsCollection).doc(id).get();
      if (docSnapshot.exists) {
        _currentRequest = RequestModel.fromMap(docSnapshot.data()!, docSnapshot.id);
      } else {
        _error = 'Request not found';
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load request details: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  Future<String> _uploadImage(Uint8List imageData, String path) async {
    final uuid = const Uuid().v4();
    final ref = _storage.ref().child('$path/$uuid.jpg');
    await ref.putData(imageData);
    return await ref.getDownloadURL();
  }

  Future<bool> submitRequest() async {
    if (_auth.currentUser == null) return false;

    _setLoading(true);
    _error = null;
    try {
      // Upload house photos
      final frontPhotoData = _requestFormData['frontPhoto'] as Uint8List?;
      final backPhotoData = _requestFormData['backPhoto'] as Uint8List?;

      String frontPhotoUrl = '';
      String backPhotoUrl = '';

      if (frontPhotoData != null) {
        frontPhotoUrl = await _uploadImage(frontPhotoData, AppConstants.houseImagesPath);
      }

      if (backPhotoData != null) {
        backPhotoUrl = await _uploadImage(backPhotoData, AppConstants.houseImagesPath);
      }

      // Generate request number
      final countQuery = await _firestore.collection(AppConstants.requestsCollection)
          .where('userId', isEqualTo: _auth.currentUser!.uid)
          .count()
          .get();

      final requestNumber = '${(countQuery.count ?? 0) + 1}';

      // Create request document
      final requestData = {
        'userId': _auth.currentUser!.uid,
        'requestNumber': requestNumber,
        'submissionDate': Timestamp.now(),
        'status': 'pending',
        'familyCardNumber': _requestFormData['familyCardNumber'],
        'nik': _requestFormData['nik'],
        'fullName': _requestFormData['fullName'],
        'birthPlace': _requestFormData['birthPlace'],
        'birthDate': Timestamp.fromDate(_requestFormData['birthDate']),
        'gender': _requestFormData['gender'],
        'occupation': _requestFormData['occupation'],
        'maritalStatus': _requestFormData['maritalStatus'],
        'province': _requestFormData['province'],
        'city': _requestFormData['city'],
        'district': _requestFormData['district'],
        'village': _requestFormData['village'],
        'fullAddress': _requestFormData['fullAddress'],
        'email': _requestFormData['email'],
        'phoneNumber': _requestFormData['phoneNumber'],
        'buildingYear': _requestFormData['buildingYear'],
        'ownershipStatus': _requestFormData['ownershipStatus'],
        'electricVoltage': _requestFormData['electricVoltage'],
        'waterStatus': _requestFormData['waterStatus'],
        'buildingArea': _requestFormData['buildingArea'],
        'landArea': _requestFormData['landArea'],
        'buildingType': _requestFormData['buildingType'],
        'frontPhotoUrl': frontPhotoUrl,
        'backPhotoUrl': backPhotoUrl,
      };

      await _firestore.collection(AppConstants.requestsCollection).add(requestData);

      // Reset form data
      _requestFormData = {};
      _currentStep = 0;

      // Refresh user requests
      await fetchUserRequests();

      return true;
    } catch (e) {
      _error = 'Failed to submit request: $e';
      debugPrint(_error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> approveRequest(String requestId) async {
    _setLoading(true);
    _error = null;
    try {
      await _firestore.collection(AppConstants.requestsCollection).doc(requestId).update({
        'status': 'approved',
        'distributionDate': Timestamp.now().toDate().toIso8601String(),
      });

      // Refresh requests
      await fetchAllRequests();

      return true;
    } catch (e) {
      _error = 'Failed to approve request: $e';
      debugPrint(_error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> rejectRequest(String requestId) async {
    _setLoading(true);
    _error = null;
    try {
      await _firestore.collection(AppConstants.requestsCollection).doc(requestId).update({
        'status': 'rejected',
      });

      // Refresh requests
      await fetchAllRequests();

      return true;
    } catch (e) {
      _error = 'Failed to reject request: $e';
      debugPrint(_error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void updateFormData(Map<String, dynamic> data) {
    _requestFormData.addAll(data);
    notifyListeners();
  }

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    _currentStep++;
    notifyListeners();
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void resetForm() {
    _requestFormData = {};
    _currentStep = 0;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
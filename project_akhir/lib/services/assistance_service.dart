import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_akhir/models/assistance_request_model.dart';

class AssistanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all assistance requests for a user
  Future<List<AssistanceRequestModel>> getUserRequests() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('assistance_requests')
          .where('userId', isEqualTo: user.uid)
          .orderBy('requestDate', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => AssistanceRequestModel.fromMap(
              doc.data() as Map<String, dynamic>, 
              doc.id
          ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get assistance requests: ${e.toString()}');
    }
  }

  // Get all assistance requests for admin review
  Future<List<AssistanceRequestModel>> getAllPendingRequests() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('assistance_requests')
          .where('status', isEqualTo: 'under consideration')
          .orderBy('requestDate', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => AssistanceRequestModel.fromMap(
              doc.data() as Map<String, dynamic>, 
              doc.id
          ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get pending requests: ${e.toString()}');
    }
  }

  // Get all approved assistance requests
  Future<List<AssistanceRequestModel>> getAllApprovedRequests() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('assistance_requests')
          .where('status', isEqualTo: 'approved')
          .orderBy('approvalDate', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => AssistanceRequestModel.fromMap(
              doc.data() as Map<String, dynamic>, 
              doc.id
          ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get approved requests: ${e.toString()}');
    }
  }

  // Get assistance request by ID
  Future<AssistanceRequestModel> getRequestById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('assistance_requests')
          .doc(id)
          .get();
      
      if (!doc.exists) {
        throw Exception('Request not found');
      }
      
      return AssistanceRequestModel.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
      );
    } catch (e) {
      throw Exception('Failed to get request details: ${e.toString()}');
    }
  }

  // Submit a new assistance request
  Future<String> submitRequest({
    required String familyCardNumber,
    required String nik,
    required String name,
    required String birthPlace,
    required DateTime birthDate,
    required String gender,
    required String occupation,
    required String maritalStatus,
    required String province,
    required String city,
    required String district,
    required String village,
    required String fullAddress,
    required String email,
    required String phoneNumber,
    required String buildingYear,
    required String ownershipStatus,
    required String electricityCapacity,
    required String waterStatus,
    required String buildingArea,
    required String landArea,
    required String buildingType,
    required List<File> photos,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    try {
      // Upload photos
      final List<String> photoUrls = await Future.wait(
        photos.asMap().entries.map((entry) {
          return _uploadFile(
            entry.value,
            'assistance_requests/${user.uid}/${DateTime.now().millisecondsSinceEpoch}_${entry.key}.jpg',
          );
        }),
      );

      // Create request
      final request = AssistanceRequestModel(
        id: '', // Will be set by Firestore
        userId: user.uid,
        name: name,
        nik: nik,
        familyCardNumber: familyCardNumber,
        birthPlace: birthPlace,
        birthDate: birthDate,
        gender: gender,
        occupation: occupation,
        maritalStatus: maritalStatus,
        province: province,
        city: city,
        district: district,
        village: village,
        fullAddress: fullAddress,
        email: email,
        phoneNumber: phoneNumber,
        buildingYear: buildingYear,
        ownershipStatus: ownershipStatus,
        electricityCapacity: electricityCapacity,
        waterStatus: waterStatus,
        buildingArea: buildingArea,
        landArea: landArea,
        buildingType: buildingType,
        photoUrls: photoUrls,
        status: 'under consideration',
        requestDate: DateTime.now(),
      );

      // Save to Firestore
      final docRef = await _firestore
          .collection('assistance_requests')
          .add(request.toMap());
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to submit request: ${e.toString()}');
    }
  }

  // Approve an assistance request (admin only)
  Future<void> approveRequest(String requestId, String adminNotes) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    try {
      await _firestore
          .collection('assistance_requests')
          .doc(requestId)
          .update({
        'status': 'approved',
        'approvalDate': FieldValue.serverTimestamp(),
        'adminId': user.uid,
        'adminNotes': adminNotes,
      });
    } catch (e) {
      throw Exception('Failed to approve request: ${e.toString()}');
    }
  }

  // Reject an assistance request (admin only)
  Future<void> rejectRequest(String requestId, String adminNotes) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }

    try {
      await _firestore
          .collection('assistance_requests')
          .doc(requestId)
          .update({
        'status': 'rejected',
        'adminId': user.uid,
        'adminNotes': adminNotes,
      });
    } catch (e) {
      throw Exception('Failed to reject request: ${e.toString()}');
    }
  }

  Future<String> _uploadFile(File file, String path) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
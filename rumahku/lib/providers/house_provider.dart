import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rumahku/models/house_model.dart';
import 'package:rumahku/utils/constants.dart';

class HouseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<HouseModel> _houses = [];
  HouseModel? _selectedHouse;
  bool _isLoading = false;
  String? _error;
  
  List<HouseModel> get houses => _houses;
  HouseModel? get selectedHouse => _selectedHouse;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  HouseProvider() {
    fetchHouses();
  }
  
  Future<void> fetchHouses() async {
    _setLoading(true);
    _error = null;
    try {
      final snapshot = await _firestore.collection(AppConstants.housesCollection).get();
      _houses = snapshot.docs
          .map((doc) => HouseModel.fromMap(doc.data(), doc.id))
          .toList();
          
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load house references: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> getHouseById(String id) async {
    _setLoading(true);
    _error = null;
    try {
      final docSnapshot = await _firestore.collection(AppConstants.housesCollection).doc(id).get();
      if (docSnapshot.exists) {
        _selectedHouse = HouseModel.fromMap(docSnapshot.data()!, docSnapshot.id);
      } else {
        _error = 'House not found';
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load house details: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> getHouseByType(String type) async {
    _setLoading(true);
    _error = null;
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.housesCollection)
          .where('type', isEqualTo: type)
          .limit(1)
          .get();
          
      if (querySnapshot.docs.isNotEmpty) {
        _selectedHouse = HouseModel.fromMap(
          querySnapshot.docs.first.data(),
          querySnapshot.docs.first.id
        );
      } else {
        _error = 'No house found with the specified type';
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load house details: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }
  
  void clearSelectedHouse() {
    _selectedHouse = null;
    notifyListeners();
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_akhir/models/house_model.dart';

class HouseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<HouseModel>> getHouseReferences() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('houses')
          .get();
      
      return snapshot.docs
          .map((doc) => HouseModel.fromMap(
              doc.data() as Map<String, dynamic>, 
              doc.id
          ))
          .toList();
    } catch (e) {
      throw Exception('Failed to get house references: ${e.toString()}');
    }
  }

  Future<HouseModel> getHouseById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('houses')
          .doc(id)
          .get();
      
      if (!doc.exists) {
        throw Exception('House not found');
      }
      
      return HouseModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Failed to get house details: ${e.toString()}');
    }
  }

  // Initialize house data in Firestore (for development purposes)
  Future<void> initializeHouseData() async {
    final List<Map<String, dynamic>> houses = [
      {
        'type': 'Tipe 36',
        'buildingArea': '36 m²',
        'landArea': '72 m²',
        'electricityCapacity': '1300watt',
        'waterStatus': 'PDAM',
        'humidityStatus': 'Cukup baik',
        'numberOfRooms': 2,
        'numberOfBathrooms': 1,
        'floorPlanImageUrl': 'https://rumahkita.id/wp-content/uploads/2021/08/Denah-Rumah-Type-36-1-lantai.jpg',
        'photoUrls': [
          'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',
          'https://images.pexels.com/photos/1396122/pexels-photo-1396122.jpeg'
        ],
        'description': 'Rumah tipe 36 dengan desain minimalis dan modern. Cocok untuk keluarga kecil.',
      },
      {
        'type': 'Tipe 45',
        'buildingArea': '45 m²',
        'landArea': '90 m²',
        'electricityCapacity': '1300watt',
        'waterStatus': 'PDAM',
        'humidityStatus': 'Baik',
        'numberOfRooms': 2,
        'numberOfBathrooms': 1,
        'floorPlanImageUrl': 'https://rumahkita.id/wp-content/uploads/2021/08/Denah-Rumah-Type-45-1-lantai.jpg',
        'photoUrls': [
          'https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg',
          'https://images.pexels.com/photos/1029599/pexels-photo-1029599.jpeg'
        ],
        'description': 'Rumah tipe 45 dengan desain minimalis dan modern. Cocok untuk keluarga sedang.',
      },
      {
        'type': 'Tipe 54',
        'buildingArea': '54 m²',
        'landArea': '120 m²',
        'electricityCapacity': '2200watt',
        'waterStatus': 'PDAM',
        'humidityStatus': 'Sangat baik',
        'numberOfRooms': 3,
        'numberOfBathrooms': 2,
        'floorPlanImageUrl': 'https://rumahkita.id/wp-content/uploads/2021/08/Denah-Rumah-Type-54-1-lantai.jpg',
        'photoUrls': [
          'https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg',
          'https://images.pexels.com/photos/1115804/pexels-photo-1115804.jpeg'
        ],
        'description': 'Rumah tipe 54 dengan desain minimalis dan modern. Cocok untuk keluarga besar.',
      },
      {
        'type': 'Tipe 60',
        'buildingArea': '60 m²',
        'landArea': '120 m²',
        'electricityCapacity': '2200watt',
        'waterStatus': 'PDAM',
        'humidityStatus': 'Sangat baik',
        'numberOfRooms': 3,
        'numberOfBathrooms': 2,
        'floorPlanImageUrl': 'https://rumahkita.id/wp-content/uploads/2021/08/Denah-Rumah-Type-60-1-lantai.jpg',
        'photoUrls': [
          'https://images.pexels.com/photos/1396132/pexels-photo-1396132.jpeg',
          'https://images.pexels.com/photos/1643384/pexels-photo-1643384.jpeg'
        ],
        'description': 'Rumah tipe 60 dengan desain minimalis dan modern. Cocok untuk keluarga besar.',
      }
    ];

    // Check if collection is empty first
    final QuerySnapshot snapshot = await _firestore
        .collection('houses')
        .limit(1)
        .get();
    
    if (snapshot.docs.isEmpty) {
      // Collection is empty, initialize with sample data
      final batch = _firestore.batch();
      
      for (final house in houses) {
        final docRef = _firestore.collection('houses').doc();
        batch.set(docRef, house);
      }
      
      await batch.commit();
    }
  }
}
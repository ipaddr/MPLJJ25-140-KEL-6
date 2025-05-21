import 'dart:async';

class HouseService {
  Future<Map<String, dynamic>?> getHouseByType(String houseType) async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Dummy data for different house types
    final Map<String, Map<String, dynamic>> dummyHouseData = {
      'Tipe 36': {
        'houseType': 'Tipe 36',
        'buildingArea': 36,
        'landArea': 72,
        'electricityCapacity': 1300,
        'waterStatus': 'PAM',
        'humidityStatus': 'Normal',
        'numberOfRooms': 2,
        'numberOfBathrooms': 1,
        'floorPlanImageUrl': 'https://via.placeholder.com/300x200?text=Denah+Tipe+36', // Replace with actual image URL
      },
      'Tipe 45': {
        'houseType': 'Tipe 45',
        'buildingArea': 45,
        'landArea': 90,
        'electricityCapacity': 2200,
        'waterStatus': 'Sumur Bor',
        'humidityStatus': 'Rendah',
        'numberOfRooms': 3,
        'numberOfBathrooms': 1,
        'floorPlanImageUrl': 'https://via.placeholder.com/300x200?text=Denah+Tipe+45', // Replace with actual image URL
      },
      // Add more dummy data for other house types as needed
    };

    // Return data based on houseType, or null if not found
    return dummyHouseData[houseType];
  }
}
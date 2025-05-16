class HouseModel {
  final String id;
  final String type;
  final String buildingArea;
  final String landArea;
  final String electricityCapacity;
  final String waterStatus;
  final String humidityStatus;
  final int numberOfRooms;
  final int numberOfBathrooms;
  final String floorPlanImageUrl;
  final List<String> photoUrls;
  final String description;

  HouseModel({
    required this.id,
    required this.type,
    required this.buildingArea,
    required this.landArea,
    required this.electricityCapacity,
    required this.waterStatus,
    required this.humidityStatus,
    required this.numberOfRooms,
    required this.numberOfBathrooms,
    required this.floorPlanImageUrl,
    required this.photoUrls,
    required this.description,
  });

  factory HouseModel.fromMap(Map<String, dynamic> map, String id) {
    return HouseModel(
      id: id,
      type: map['type'] ?? '',
      buildingArea: map['buildingArea'] ?? '',
      landArea: map['landArea'] ?? '',
      electricityCapacity: map['electricityCapacity'] ?? '',
      waterStatus: map['waterStatus'] ?? '',
      humidityStatus: map['humidityStatus'] ?? '',
      numberOfRooms: map['numberOfRooms'] ?? 0,
      numberOfBathrooms: map['numberOfBathrooms'] ?? 0,
      floorPlanImageUrl: map['floorPlanImageUrl'] ?? '',
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'buildingArea': buildingArea,
      'landArea': landArea,
      'electricityCapacity': electricityCapacity,
      'waterStatus': waterStatus,
      'humidityStatus': humidityStatus,
      'numberOfRooms': numberOfRooms,
      'numberOfBathrooms': numberOfBathrooms,
      'floorPlanImageUrl': floorPlanImageUrl,
      'photoUrls': photoUrls,
      'description': description,
    };
  }
}
class HouseModel {
  final String id;
  final String type;
  final double buildingArea;
  final double landArea;
  final String electricVoltage;
  final String waterStatus;
  final String humidityStatus;
  final int bedrooms;
  final int bathrooms;
  final String floorPlanUrl;
  final List<String> imageUrls;
  final String description;

  HouseModel({
    required this.id,
    required this.type,
    required this.buildingArea,
    required this.landArea,
    required this.electricVoltage,
    required this.waterStatus,
    required this.humidityStatus,
    required this.bedrooms,
    required this.bathrooms,
    required this.floorPlanUrl,
    required this.imageUrls,
    required this.description,
  });

  factory HouseModel.fromMap(Map<String, dynamic> map, String id) {
    return HouseModel(
      id: id,
      type: map['type'] ?? '',
      buildingArea: (map['buildingArea'] ?? 0).toDouble(),
      landArea: (map['landArea'] ?? 0).toDouble(),
      electricVoltage: map['electricVoltage'] ?? '',
      waterStatus: map['waterStatus'] ?? '',
      humidityStatus: map['humidityStatus'] ?? '',
      bedrooms: map['bedrooms'] ?? 0,
      bathrooms: map['bathrooms'] ?? 0,
      floorPlanUrl: map['floorPlanUrl'] ?? '',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'buildingArea': buildingArea,
      'landArea': landArea,
      'electricVoltage': electricVoltage,
      'waterStatus': waterStatus,
      'humidityStatus': humidityStatus,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'floorPlanUrl': floorPlanUrl,
      'imageUrls': imageUrls,
      'description': description,
    };
  }
}
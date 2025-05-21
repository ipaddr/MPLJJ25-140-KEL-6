import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  final String id;
  final String userId;
  final String requestNumber;
  final DateTime submissionDate;
  final String status; // 'pending', 'approved', 'rejected'
  final String? distributionDate;
  
  // Personal Data
  final String familyCardNumber;
  final String nik;
  final String fullName;
  final String birthPlace;
  final DateTime birthDate;
  final String gender;
  final String occupation;
  final String maritalStatus;
  final String province;
  final String city;
  final String district;
  final String village;
  final String fullAddress;
  final String email;
  final String phoneNumber;
  
  // House Data
  final String buildingYear;
  final String ownershipStatus;
  final String electricVoltage;
  final String waterStatus;
  final double buildingArea;
  final double landArea;
  final String buildingType;
  final String frontPhotoUrl;
  final String backPhotoUrl;

  RequestModel({
    required this.id,
    required this.userId,
    required this.requestNumber,
    required this.submissionDate,
    required this.status,
    this.distributionDate,
    required this.familyCardNumber,
    required this.nik,
    required this.fullName,
    required this.birthPlace,
    required this.birthDate,
    required this.gender,
    required this.occupation,
    required this.maritalStatus,
    required this.province,
    required this.city,
    required this.district,
    required this.village,
    required this.fullAddress,
    required this.email,
    required this.phoneNumber,
    required this.buildingYear,
    required this.ownershipStatus,
    required this.electricVoltage,
    required this.waterStatus,
    required this.buildingArea,
    required this.landArea,
    required this.buildingType,
    required this.frontPhotoUrl,
    required this.backPhotoUrl,
  });

  factory RequestModel.fromMap(Map<String, dynamic> map, String id) {
    return RequestModel(
      id: id,
      userId: map['userId'] ?? '',
      requestNumber: map['requestNumber'] ?? '',
      submissionDate: (map['submissionDate'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      distributionDate: map['distributionDate'],
      familyCardNumber: map['familyCardNumber'] ?? '',
      nik: map['nik'] ?? '',
      fullName: map['fullName'] ?? '',
      birthPlace: map['birthPlace'] ?? '',
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      gender: map['gender'] ?? '',
      occupation: map['occupation'] ?? '',
      maritalStatus: map['maritalStatus'] ?? '',
      province: map['province'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      village: map['village'] ?? '',
      fullAddress: map['fullAddress'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      buildingYear: map['buildingYear'] ?? '',
      ownershipStatus: map['ownershipStatus'] ?? '',
      electricVoltage: map['electricVoltage'] ?? '',
      waterStatus: map['waterStatus'] ?? '',
      buildingArea: (map['buildingArea'] ?? 0).toDouble(),
      landArea: (map['landArea'] ?? 0).toDouble(),
      buildingType: map['buildingType'] ?? '',
      frontPhotoUrl: map['frontPhotoUrl'] ?? '',
      backPhotoUrl: map['backPhotoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'requestNumber': requestNumber,
      'submissionDate': Timestamp.fromDate(submissionDate),
      'status': status,
      'distributionDate': distributionDate,
      'familyCardNumber': familyCardNumber,
      'nik': nik,
      'fullName': fullName,
      'birthPlace': birthPlace,
      'birthDate': Timestamp.fromDate(birthDate),
      'gender': gender,
      'occupation': occupation,
      'maritalStatus': maritalStatus,
      'province': province,
      'city': city,
      'district': district,
      'village': village,
      'fullAddress': fullAddress,
      'email': email,
      'phoneNumber': phoneNumber,
      'buildingYear': buildingYear,
      'ownershipStatus': ownershipStatus,
      'electricVoltage': electricVoltage,
      'waterStatus': waterStatus,
      'buildingArea': buildingArea,
      'landArea': landArea,
      'buildingType': buildingType,
      'frontPhotoUrl': frontPhotoUrl,
      'backPhotoUrl': backPhotoUrl,
    };
  }

  RequestModel copyWith({
    String? id,
    String? userId,
    String? requestNumber,
    DateTime? submissionDate,
    String? status,
    String? distributionDate,
    String? familyCardNumber,
    String? nik,
    String? fullName,
    String? birthPlace,
    DateTime? birthDate,
    String? gender,
    String? occupation,
    String? maritalStatus,
    String? province,
    String? city,
    String? district,
    String? village,
    String? fullAddress,
    String? email,
    String? phoneNumber,
    String? buildingYear,
    String? ownershipStatus,
    String? electricVoltage,
    String? waterStatus,
    double? buildingArea,
    double? landArea,
    String? buildingType,
    String? frontPhotoUrl,
    String? backPhotoUrl,
  }) {
    return RequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      requestNumber: requestNumber ?? this.requestNumber,
      submissionDate: submissionDate ?? this.submissionDate,
      status: status ?? this.status,
      distributionDate: distributionDate ?? this.distributionDate,
      familyCardNumber: familyCardNumber ?? this.familyCardNumber,
      nik: nik ?? this.nik,
      fullName: fullName ?? this.fullName,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      province: province ?? this.province,
      city: city ?? this.city,
      district: district ?? this.district,
      village: village ?? this.village,
      fullAddress: fullAddress ?? this.fullAddress,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      buildingYear: buildingYear ?? this.buildingYear,
      ownershipStatus: ownershipStatus ?? this.ownershipStatus,
      electricVoltage: electricVoltage ?? this.electricVoltage,
      waterStatus: waterStatus ?? this.waterStatus,
      buildingArea: buildingArea ?? this.buildingArea,
      landArea: landArea ?? this.landArea,
      buildingType: buildingType ?? this.buildingType,
      frontPhotoUrl: frontPhotoUrl ?? this.frontPhotoUrl,
      backPhotoUrl: backPhotoUrl ?? this.backPhotoUrl,
    );
  }
}
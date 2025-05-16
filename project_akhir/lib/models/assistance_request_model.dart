import 'package:cloud_firestore/cloud_firestore.dart';

class AssistanceRequestModel {
  final String id;
  final String userId;
  final String name;
  final String nik;
  final String familyCardNumber;
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
  
  // House data
  final String buildingYear;
  final String ownershipStatus;
  final String electricityCapacity;
  final String waterStatus;
  final String buildingArea;
  final String landArea;
  final String buildingType;
  final List<String> photoUrls;
  
  // Request status
  final String status; // under consideration, approved, rejected
  final DateTime requestDate;
  final DateTime? approvalDate;
  final String? adminId;
  final String? adminNotes;

  AssistanceRequestModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.nik,
    required this.familyCardNumber,
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
    required this.electricityCapacity,
    required this.waterStatus,
    required this.buildingArea,
    required this.landArea,
    required this.buildingType,
    required this.photoUrls,
    required this.status,
    required this.requestDate,
    this.approvalDate,
    this.adminId,
    this.adminNotes,
  });

  factory AssistanceRequestModel.fromMap(Map<String, dynamic> map, String id) {
    return AssistanceRequestModel(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      nik: map['nik'] ?? '',
      familyCardNumber: map['familyCardNumber'] ?? '',
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
      electricityCapacity: map['electricityCapacity'] ?? '',
      waterStatus: map['waterStatus'] ?? '',
      buildingArea: map['buildingArea'] ?? '',
      landArea: map['landArea'] ?? '',
      buildingType: map['buildingType'] ?? '',
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      status: map['status'] ?? 'under consideration',
      requestDate: (map['requestDate'] as Timestamp).toDate(),
      approvalDate: map['approvalDate'] != null 
          ? (map['approvalDate'] as Timestamp).toDate() 
          : null,
      adminId: map['adminId'],
      adminNotes: map['adminNotes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'nik': nik,
      'familyCardNumber': familyCardNumber,
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
      'electricityCapacity': electricityCapacity,
      'waterStatus': waterStatus,
      'buildingArea': buildingArea,
      'landArea': landArea,
      'buildingType': buildingType,
      'photoUrls': photoUrls,
      'status': status,
      'requestDate': Timestamp.fromDate(requestDate),
      'approvalDate': approvalDate != null ? Timestamp.fromDate(approvalDate!) : null,
      'adminId': adminId,
      'adminNotes': adminNotes,
    };
  }

  AssistanceRequestModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? nik,
    String? familyCardNumber,
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
    String? electricityCapacity,
    String? waterStatus,
    String? buildingArea,
    String? landArea,
    String? buildingType,
    List<String>? photoUrls,
    String? status,
    DateTime? requestDate,
    DateTime? approvalDate,
    String? adminId,
    String? adminNotes,
  }) {
    return AssistanceRequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      nik: nik ?? this.nik,
      familyCardNumber: familyCardNumber ?? this.familyCardNumber,
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
      electricityCapacity: electricityCapacity ?? this.electricityCapacity,
      waterStatus: waterStatus ?? this.waterStatus,
      buildingArea: buildingArea ?? this.buildingArea,
      landArea: landArea ?? this.landArea,
      buildingType: buildingType ?? this.buildingType,
      photoUrls: photoUrls ?? this.photoUrls,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      approvalDate: approvalDate ?? this.approvalDate,
      adminId: adminId ?? this.adminId,
      adminNotes: adminNotes ?? this.adminNotes,
    );
  }
}
class UserModel {
  final String id;
  final String nik;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String username;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final String? ktpImageUrl;
  final String? selfieImageUrl;
  final String? gender;
  final int? familyMembers;
  final String? aidStatus;
  final String? residenceStatus;
  final String? ownershipYear;
  final String? ownershipStatus;
  final String? waterStatus;
  final String? humidityStatus;
  final String? environmentStatus;

  UserModel({
    required this.id,
    required this.nik,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.username,
    this.profileImageUrl,
    this.coverImageUrl,
    this.ktpImageUrl,
    this.selfieImageUrl,
    this.gender,
    this.familyMembers,
    this.aidStatus,
    this.residenceStatus,
    this.ownershipYear,
    this.ownershipStatus,
    this.waterStatus,
    this.humidityStatus,
    this.environmentStatus,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      nik: map['nik'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      coverImageUrl: map['coverImageUrl'],
      ktpImageUrl: map['ktpImageUrl'],
      selfieImageUrl: map['selfieImageUrl'],
      gender: map['gender'],
      familyMembers: map['familyMembers'],
      aidStatus: map['aidStatus'],
      residenceStatus: map['residenceStatus'],
      ownershipYear: map['ownershipYear'],
      ownershipStatus: map['ownershipStatus'],
      waterStatus: map['waterStatus'],
      humidityStatus: map['humidityStatus'],
      environmentStatus: map['environmentStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nik': nik,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'ktpImageUrl': ktpImageUrl,
      'selfieImageUrl': selfieImageUrl,
      'gender': gender,
      'familyMembers': familyMembers,
      'aidStatus': aidStatus,
      'residenceStatus': residenceStatus,
      'ownershipYear': ownershipYear,
      'ownershipStatus': ownershipStatus,
      'waterStatus': waterStatus,
      'humidityStatus': humidityStatus,
      'environmentStatus': environmentStatus,
    };
  }

  UserModel copyWith({
    String? id,
    String? nik,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? username,
    String? profileImageUrl,
    String? coverImageUrl,
    String? ktpImageUrl,
    String? selfieImageUrl,
    String? gender,
    int? familyMembers,
    String? aidStatus,
    String? residenceStatus,
    String? ownershipYear,
    String? ownershipStatus,
    String? waterStatus,
    String? humidityStatus,
    String? environmentStatus,
  }) {
    return UserModel(
      id: id ?? this.id,
      nik: nik ?? this.nik,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      ktpImageUrl: ktpImageUrl ?? this.ktpImageUrl,
      selfieImageUrl: selfieImageUrl ?? this.selfieImageUrl,
      gender: gender ?? this.gender,
      familyMembers: familyMembers ?? this.familyMembers,
      aidStatus: aidStatus ?? this.aidStatus,
      residenceStatus: residenceStatus ?? this.residenceStatus,
      ownershipYear: ownershipYear ?? this.ownershipYear,
      ownershipStatus: ownershipStatus ?? this.ownershipStatus,
      waterStatus: waterStatus ?? this.waterStatus,
      humidityStatus: humidityStatus ?? this.humidityStatus,
      environmentStatus: environmentStatus ?? this.environmentStatus,
    );
  }
}
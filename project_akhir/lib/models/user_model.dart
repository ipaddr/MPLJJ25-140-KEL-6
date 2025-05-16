class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String nik;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final String? gender;
  final Map<String, dynamic>? additionalInfo;
  final bool isAdmin;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.nik,
    this.profileImageUrl,
    this.coverImageUrl,
    this.gender,
    this.additionalInfo,
    this.isAdmin = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      nik: map['nik'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      coverImageUrl: map['coverImageUrl'],
      gender: map['gender'],
      additionalInfo: map['additionalInfo'],
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'nik': nik,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'gender': gender,
      'additionalInfo': additionalInfo,
      'isAdmin': isAdmin,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? nik,
    String? profileImageUrl,
    String? coverImageUrl,
    String? gender,
    Map<String, dynamic>? additionalInfo,
    bool? isAdmin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nik: nik ?? this.nik,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      gender: gender ?? this.gender,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

class AdminModel extends UserModel {
  final String nip;
  final String employmentStatus;
  final String appointmentYear;
  final String placementArea;
  final String grade;

  AdminModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required String super.nik,
    required this.nip,
    required this.employmentStatus,
    required this.appointmentYear,
    required this.placementArea,
    required this.grade,
    super.profileImageUrl,
    super.coverImageUrl,
    super.gender,
    super.additionalInfo,
    super.isAdmin = true,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      nik: map['nik'] ?? '',
      nip: map['nip'] ?? '',
      employmentStatus: map['employmentStatus'] ?? '',
      appointmentYear: map['appointmentYear'] ?? '',
      placementArea: map['placementArea'] ?? '',
      grade: map['grade'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      coverImageUrl: map['coverImageUrl'],
      gender: map['gender'],
      additionalInfo: map['additionalInfo'],
      isAdmin: map['isAdmin'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'nip': nip,
      'employmentStatus': employmentStatus,
      'appointmentYear': appointmentYear,
      'placementArea': placementArea,
      'grade': grade,
      'isAdmin': true,
    });
    return map;
  }

  @override
  AdminModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? nik,
    String? nip,
    String? employmentStatus,
    String? appointmentYear,
    String? placementArea,
    String? grade,
    String? profileImageUrl,
    String? coverImageUrl,
    String? gender,
    Map<String, dynamic>? additionalInfo,
    bool? isAdmin,
  }) {
    return AdminModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nik: nik ?? this.nik,
      nip: nip ?? this.nip,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      appointmentYear: appointmentYear ?? this.appointmentYear,
      placementArea: placementArea ?? this.placementArea,
      grade: grade ?? this.grade,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      gender: gender ?? this.gender,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
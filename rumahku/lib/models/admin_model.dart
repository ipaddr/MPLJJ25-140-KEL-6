class AdminModel {
  final String id;
  final String nip;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String employmentStatus;
  final String appointmentYear;
  final String placementArea;
  final String rank;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final String? gender;

  AdminModel({
    required this.id,
    required this.nip,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.employmentStatus,
    required this.appointmentYear,
    required this.placementArea,
    required this.rank,
    this.profileImageUrl,
    this.coverImageUrl,
    this.gender,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map, String id) {
    return AdminModel(
      id: id,
      nip: map['nip'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      employmentStatus: map['employmentStatus'] ?? '',
      appointmentYear: map['appointmentYear'] ?? '',
      placementArea: map['placementArea'] ?? '',
      rank: map['rank'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      coverImageUrl: map['coverImageUrl'],
      gender: map['gender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nip': nip,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'employmentStatus': employmentStatus,
      'appointmentYear': appointmentYear,
      'placementArea': placementArea,
      'rank': rank,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'gender': gender,
    };
  }

  AdminModel copyWith({
    String? id,
    String? nip,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? employmentStatus,
    String? appointmentYear,
    String? placementArea,
    String? rank,
    String? profileImageUrl,
    String? coverImageUrl,
    String? gender,
  }) {
    return AdminModel(
      id: id ?? this.id,
      nip: nip ?? this.nip,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      employmentStatus: employmentStatus ?? this.employmentStatus,
      appointmentYear: appointmentYear ?? this.appointmentYear,
      placementArea: placementArea ?? this.placementArea,
      rank: rank ?? this.rank,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      gender: gender ?? this.gender,
    );
  }
}
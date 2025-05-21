class User {
  final String uid;
  final String? email;
  final String? username;
  final String? nik;

  User({
    required this.uid,
    this.email,
    this.username,
    this.nik,
  });
}
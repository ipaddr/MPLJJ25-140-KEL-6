class AppConstants {
  // API Endpoints
  static const String mediaStackBaseUrl = 'http://api.mediastack.com/v1/news';

  // Storage Paths
  static const String userProfileImagesPath = 'users/profile_images';
  static const String userCoverImagesPath = 'users/cover_images';
  static const String userKtpImagesPath = 'users/ktp_images';
  static const String userSelfieImagesPath = 'users/selfie_images';
  static const String adminProfileImagesPath = 'admins/profile_images';
  static const String adminCoverImagesPath = 'admins/cover_images';
  static const String houseImagesPath = 'houses/images';

  // Collection Names
  static const String usersCollection = 'users';
  static const String adminsCollection = 'admins';
  static const String housesCollection = 'houses';
  static const String requestsCollection = 'requests';
  static const String distributionsCollection = 'distributions';
  static const String newsCollection = 'news';

  // Image Placeholders
  static const String placeholderProfileImage = 'https://firebasestorage.googleapis.com/v0/b/rumahku-b349e.appspot.com/o/placeholders%2Fprofile_placeholder.png?alt=media';
  static const String placeholderCoverImage = 'https://firebasestorage.googleapis.com/v0/b/rumahku-b349e.appspot.com/o/placeholders%2Fcover_placeholder.jpg?alt=media';
  static const String placeholderHouseImage = 'https://firebasestorage.googleapis.com/v0/b/rumahku-b349e.appspot.com/o/placeholders%2Fhouse_placeholder.jpg?alt=media';

  // Default House Types
  static List<String> houseTypes = ['Tipe 36', 'Tipe 45', 'Tipe 54', 'Tipe 60'];
}
class NewsModel {
  final String title;
  final String description;
  final String image;
  final String url;
  final String imageUrl;
  final String source;
  final DateTime publishedAt;

  NewsModel({
    required this.title,
    required this.description,
    this.image = '',  // Berikan nilai default jika tidak ada
    required this.url,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      title: map['title'] ?? 'Tidak ada judul',
      description: map['description'] ?? 'Tidak ada deskripsi',
      image: 'assets/images/house_background.png', // Nilai default lokal
      url: map['url'] ?? '',
      imageUrl: map['image'] ?? '', // Jika kosong, berikan fallback di tempat lain
      source: map['source'] ?? 'Tidak diketahui',
      publishedAt: map['published_at'] != null
          ? DateTime.parse(map['published_at'])
          : DateTime.now(),
    );
  }
}

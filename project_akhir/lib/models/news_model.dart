class NewsModel {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String source;
  final DateTime publishedAt;

  NewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      imageUrl: map['image'] ?? '',
      source: map['source'] ?? '',
      publishedAt: DateTime.parse(map['published_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
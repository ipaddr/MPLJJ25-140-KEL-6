class NewsModel {
  final String id;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String source;
  final DateTime publishedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
  });

  factory NewsModel.fromMap(Map<String, dynamic> map, String id) {
    return NewsModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      imageUrl: map['image'] ?? '',
      source: map['source'] ?? '',
      publishedAt: DateTime.parse(map['published_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  factory NewsModel.fromMediaStack(Map<String, dynamic> map) {
    return NewsModel(
      id: map['url'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      imageUrl: map['image'] ?? '',
      source: map['source'] ?? '',
      publishedAt: DateTime.parse(map['published_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'image': imageUrl,
      'source': source,
      'published_at': publishedAt.toIso8601String(),
    };
  }
}
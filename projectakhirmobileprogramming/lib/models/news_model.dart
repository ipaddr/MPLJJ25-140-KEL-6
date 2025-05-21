class News {
  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? image;
  final String? language;
  final String? category;
  final String? publishedAt; // Keeping as String based on your previous request
  final String? source;
  final String? country;
  final String? content;

  News({
    this.author,
    this.title,
    this.description,
    this.url,
    this.image,
    this.language,
    this.category,
    this.publishedAt,
    this.source,
    this.country,
    this.content,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      image: json['image'],
      language: json['language'],
      category: json['category'],
      publishedAt: json['published_at'],
      source: json['source'],
      country: json['country'],
      content: json['content'],
    );
  }
}
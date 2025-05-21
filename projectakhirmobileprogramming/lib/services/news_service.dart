import 'package:projectakhirmobileprogramming/models/news_model.dart';

class NewsService {
  Future<List<News>> getLatestNews() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    // Placeholder data for a list of news articles
    final List<Map<String, dynamic>> placeholderData = [
      {
        "author": "Fulan bin Fulan",
        "title": "Harga Properti di Kota X Naik Pesat",
        "description": "Kenaikan harga properti di Kota X dipicu oleh beberapa faktor.",
        "url": "http://example.com/berita/properti-naik",
        "image": "https://via.placeholder.com/150",
        "language": "id",
        "category": "business",
        "published_at": "2023-10-27T10:00:00Z",
        "source": "Sumber Berita A",
        "country": "id",
        "content": "Detail lengkap mengenai kenaikan harga properti..."
      },
      {
        "author": "Fulana binti Fulan",
        "title": "Tips Memilih Material Bangunan Berkualitas",
        "description": "Memilih material bangunan yang tepat sangat penting.",
        "url": "http://example.com/berita/material-bangunan",
        "image": "https://via.placeholder.com/150",
        "language": "id",
        "category": "science",
        "published_at": "2023-10-26T15:30:00Z",
        "source": "Sumber Berita B",
        "country": "id",
        "content": "Penjelasan rinci tentang jenis material bangunan..."
      },
      {
        "author": null,
        "title": "Pemerintah Luncurkan Program Subsidi Perumahan",
        "description": "Program baru untuk membantu masyarakat memiliki rumah.",
        "url": "http://example.com/berita/subsidi-perumahan",
        "image": "https://via.placeholder.com/150",
        "language": "id",
        "category": "general",
        "published_at": "2023-10-25T09:00:00Z",
        "source": "Sumber Berita C",
        "country": "id",
        "content": "Informasi detail tentang program subsidi perumahan..."
      },
    ];

    // Convert placeholder data to a list of News objects
    final List<News> newsList = placeholderData.map((data) => News.fromJson(data)).toList();

    return newsList;
  }
}
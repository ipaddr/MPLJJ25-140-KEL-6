import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:project_akhir/models/news_model.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> _news = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NewsModel> get news => _news;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNews() async {
    _setLoading(true);
    _clearError();

    try {
      final apiKey = dotenv.env['MEDIASTACK_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('MediaStack API key tidak ditemukan');
      }

      final url = Uri.parse(
        'https://api.mediastack.com/v1/news?access_key=$apiKey&categories=general&languages=id&keywords=perumahan,rumah,bantuan,subsidi&limit=10'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        if (jsonData['data'] != null) {
          final List<dynamic> newsData = jsonData['data'];
          _news = newsData
              .where((item) => item['image'] != null && item['image'].isNotEmpty)
              .map((item) => NewsModel.fromMap(item))
              .toList();
          
          // Urutkan berdasarkan tanggal terbaru
          _news.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
        }

        // Jika kosong, pakai fallback dummy
        if (_news.isEmpty) {
          _addDummyNews();
        }
      } else {
        throw Exception('Gagal memuat berita: ${response.statusCode}');
      }
    } catch (e) {
      _setError(e.toString());
      _addDummyNews();
    } finally {
      _setLoading(false);
    }
  }
void _addDummyNews() {
  _news = [
    NewsModel(
      title: 'Kenali Syarat Rumah Bersanitasi Berikut!',
      description:
          'Simak berbagai hal yang perlu diperhatikan agar rumah memenuhi standar sanitasi...',
      image: 'assets/images/house_background.png',
      imageUrl: 'https://via.placeholder.com/300x200.png?text=Rumah+Sehat',
      publishedAt: DateTime.now(),
      source: 'Berita Lokal',
      url: '',
    ),
    NewsModel(
      title: 'Program Rumah Sehat Nasional Diperluas!',
      description:
          'Pemerintah menargetkan perluasan program rumah sehat hingga ke pelosok...',
      image: 'assets/images/house_background.png',
      imageUrl: 'https://via.placeholder.com/300x200.png?text=Program+Rumah',
      publishedAt: DateTime.now().subtract(Duration(days: 1)),
      source: 'Berita Lokal',
      url: '',
    ),
  ];

  notifyListeners();
}



  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
    }
}

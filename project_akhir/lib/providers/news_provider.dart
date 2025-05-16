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
        throw Exception('MediaStack API key not found');
      }

      final url = Uri.parse(
        'http://api.mediastack.com/v1/news?access_key=$apiKey&categories=general&languages=id&keywords=perumahan,rumah,bantuan,subsidi&limit=10'
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
          
          // Sort by date (newest first)
          _news.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
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
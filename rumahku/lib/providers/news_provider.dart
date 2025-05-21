import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rumahku/models/news_model.dart';
import 'package:rumahku/utils/constants.dart';

class NewsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<NewsModel> _news = [];
  NewsModel? _selectedNews;
  bool _isLoading = false;
  String? _error;
  
  List<NewsModel> get news => _news;
  NewsModel? get selectedNews => _selectedNews;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  NewsProvider() {
    fetchNews();
  }
  
  Future<void> fetchNews() async {
    _setLoading(true);
    _error = null;
    try {
      // First try to get cached news from Firestore
      final cachedNews = await _fetchCachedNews();
      
      if (cachedNews.isNotEmpty) {
        _news = cachedNews;
        notifyListeners();
      }
      
      // Then fetch fresh news from MediaStack API
      await _fetchFreshNews();
    } catch (e) {
      _error = 'Failed to load news: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }
  
  Future<List<NewsModel>> _fetchCachedNews() async {
    try {
      final snapshot = await _firestore.collection(AppConstants.newsCollection)
          .orderBy('published_at', descending: true)
          .limit(10)
          .get();
          
      return snapshot.docs
          .map((doc) => NewsModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error fetching cached news: $e');
      return [];
    }
  }
  
  Future<void> _fetchFreshNews() async {
    try {
      final apiKey = dotenv.env['MEDIASTACK_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        _error = 'MediaStack API key not found';
        return;
      }
      
      final response = await http.get(Uri.parse(
        '${AppConstants.mediaStackBaseUrl}?access_key=$apiKey&categories=general&keywords=housing,property,perumahan,rumah&languages=en,id&limit=10'
      ));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['data'];
        
        _news = articles.map((article) => NewsModel.fromMediaStack(article)).toList();
        
        // Cache news in Firestore
        _cacheNews(_news);
        
        notifyListeners();
      } else {
        _error = 'Failed to load news: ${response.statusCode}';
        debugPrint(_error);
      }
    } catch (e) {
      _error = 'Failed to load news: $e';
      debugPrint(_error);
    }
  }
  
  Future<void> _cacheNews(List<NewsModel> news) async {
    try {
      final batch = _firestore.batch();
      
      for (final newsItem in news) {
        final docRef = _firestore.collection(AppConstants.newsCollection).doc(newsItem.id);
        batch.set(docRef, newsItem.toMap());
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint('Error caching news: $e');
    }
  }
  
  void selectNews(NewsModel news) {
    _selectedNews = news;
    notifyListeners();
  }
  
  void clearSelectedNews() {
    _selectedNews = null;
    notifyListeners();
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
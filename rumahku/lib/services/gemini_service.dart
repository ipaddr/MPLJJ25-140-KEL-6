import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  GenerativeModel? _model;
  
  factory GeminiService() {
    return _instance;
  }
  
  GeminiService._internal() {
    _initialize();
  }
  
  Future<void> _initialize() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    
    if (apiKey != null && apiKey.isNotEmpty) {
      _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    }
  }
  
  Future<String> generateResponse(String prompt) async {
    if (_model == null) {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        return 'API key not configured. Please add your Gemini API key to the .env file.';
      }
      
      await _initialize();
    }
    
    try {
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      return response.text ?? 'No response generated';
    } catch (e) {
      return 'Error generating response: $e';
    }
  }
}
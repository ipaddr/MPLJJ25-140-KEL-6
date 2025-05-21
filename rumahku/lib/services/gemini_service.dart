import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  GenerativeModel? _model;

  factory GeminiService() => _instance;

  GeminiService._internal() {
    _initialize();
  }

  Future<void> _initialize() async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];

    if (apiKey != null && apiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-pro', // ✅ HANYA 'gemini-pro'
        apiKey: dotenv.env['GEMINI_API_KEY']!,
      );
    }
  }

  Future<String> generateResponse(String prompt) async {
    if (_model == null) {
      await _initialize();
      if (_model == null) return 'Model not initialized';
    }

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text ?? 'No response';
    } catch (e) {
      return 'Error: $e';
    }
  }
}

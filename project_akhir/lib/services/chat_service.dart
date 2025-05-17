import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:project_akhir/models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GenerativeModel _model;

  ChatService() {
    final apiKey = "AIzaSyBGpKuFgDRnjg2-CpRPGojxXWZHek342kU";
    if (apiKey != null && apiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-pro', // Menggunakan model text-only
        apiKey: apiKey,
      );
    }
  }

  Future<List<MessageModel>> getChatHistory() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login');
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => MessageModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id
      ))
          .toList()
          .reversed
          .toList(); // Mengurutkan pesan dari yang terlama
    } catch (e) {
      throw Exception('Gagal mengambil riwayat chat: ${e.toString()}');
    }
  }

  Future<MessageModel> sendMessage(String text) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login');
    }

    try {
      // Membuat pesan pengguna
      final userMessage = MessageModel(
        id: '',
        text: text,
        timestamp: DateTime.now(),
        senderId: user.uid,
        isUserMessage: true,
      );

      // Menyimpan pesan pengguna ke Firestore
      final userMsgRef = await _firestore
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add(userMessage.toMap());

      // Mendapatkan respons dari Gemini AI
      final content = [Content.text(text)];
      final response = await _model.generateContent(content);
      final aiResponseText = response.text ?? 'Maaf, saya tidak dapat memproses pertanyaan Anda saat ini.';

      // Membuat pesan AI
      final aiMessage = MessageModel(
        id: '',
        text: aiResponseText,
        timestamp: DateTime.now(),
        senderId: 'ai-assistant',
        isUserMessage: false,
      );

      // Menyimpan pesan AI ke Firestore
      await _firestore
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add(aiMessage.toMap());

      return aiMessage;
    } catch (e) {
      // Jika terjadi error, kirim pesan error
      final errorMessage = MessageModel(
        id: '',
        text: 'Maaf, terjadi kesalahan saat memproses pesan Anda. Silakan coba lagi nanti.',
        timestamp: DateTime.now(),
        senderId: 'ai-assistant',
        isUserMessage: false,
      );

      await _firestore
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add(errorMessage.toMap());

      return errorMessage;
    }
  }
}

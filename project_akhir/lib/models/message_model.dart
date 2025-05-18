import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String text;
  final DateTime timestamp;
  final String senderId;
  final bool isUserMessage;

  MessageModel({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.senderId,
    required this.isUserMessage,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      text: map['text'] ?? '',
      senderId: map['senderId'] ?? '',
      timestamp: map['timestamp'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
          : (map['timestamp'] as Timestamp).toDate(),
      isUserMessage: map['isUserMessage'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'senderId': senderId,
      'isUserMessage': isUserMessage,
    };
  }
}
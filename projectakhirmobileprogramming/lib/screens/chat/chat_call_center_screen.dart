import 'package:flutter/material.dart';

class ChatCallCenterScreen extends StatefulWidget {
  const ChatCallCenterScreen({Key? key}) : super(key: key);

  @override
  _ChatCallCenterScreenState createState() => _ChatCallCenterScreenState();
}

class _ChatCallCenterScreenState extends State<ChatCallCenterScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Center Chat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Area untuk menampilkan pesan (placeholder)
          Expanded(
            child: ListView.builder(
              reverse: true, // Untuk menampilkan pesan terbaru di bawah
              itemCount: 0, // Ganti dengan jumlah pesan sebenarnya
              itemBuilder: (context, index) {
                // Placeholder untuk item pesan
                return const ListTile(
                  title: Text('Pesan Placeholder'),
                );
              },
            ),
          ),
          // Area input pesan
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan Anda...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // TODO: Implement logic to send message
                      if (_messageController.text.isNotEmpty) {
                        print('Pesan terkirim: ${_messageController.text}');
                        _messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
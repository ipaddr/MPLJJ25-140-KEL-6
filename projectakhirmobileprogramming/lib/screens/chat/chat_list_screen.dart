import 'package:flutter/material.dart';
import 'package:projectakhirmobileprogramming/screens/chat/chat_ai_screen.dart';
import 'package:projectakhirmobileprogramming/screens/chat/chat_call_center_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _chatOptions = ['RumahAI', 'Call Center'];
  List<String> _filteredChatOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredChatOptions = _chatOptions;
    _searchController.addListener(_filterChatOptions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChatOptions() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChatOptions = _chatOptions
          .where((option) => option.toLowerCase().contains(query))
          .toList();
    });
  }

  void _navigateToChat(String chatOption) {
    if (chatOption == 'RumahAI') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatAiScreen()),
      );
    } else if (chatOption == 'Call Center') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatCallCenterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search chat...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredChatOptions.length,
              itemBuilder: (context, index) {
                final option = _filteredChatOptions[index];
                return ListTile(
                  title: Text(option),
                  onTap: () => _navigateToChat(option),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

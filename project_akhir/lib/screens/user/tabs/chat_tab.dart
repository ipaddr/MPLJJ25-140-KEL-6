import 'package:flutter/material.dart';
import 'package:project_akhir/screens/user/chat/chat_ai_screen.dart';
import 'package:project_akhir/screens/user/chat/chat_call_center_screen.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFeccbdd), // Warna AppBar
        elevation: 0,
        foregroundColor: const Color(0xFF555555),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 18,
            child: const Text(
              '2',
              style: TextStyle(
                color: Color(0xFF555555),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Color(0xFF555555)),
                suffixIcon:
                    const Icon(Icons.keyboard_voice, color: Color(0xFF555555)),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _AnimatedChatItemWidget(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: const Icon(
                      Icons.android,
                      color: Colors.green,
                    ),
                  ),
                  name: 'rumahAI',
                  lastMessage:
                      'Hey, hi there! Need some help at day, I meet someone special today.',
                  time: '17:42',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatAIScreen(),
                      ),
                    );
                  },
                ),
                _AnimatedChatItemWidget(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.orange[100],
                    child: const Icon(
                      Icons.headset_mic,
                      color: Colors.orange,
                    ),
                  ),
                  name: 'Call Center',
                  lastMessage:
                      'Hey, hi there! Need some help at day, I meet someone special today.',
                  time: '11:20',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChatCallCenterScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedChatItemWidget extends StatefulWidget {
  final Widget avatar;
  final String name;
  final String lastMessage;
  final String time;
  final VoidCallback onTap;

  const _AnimatedChatItemWidget({
    required this.avatar,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.onTap,
  });

  @override
  State<_AnimatedChatItemWidget> createState() =>
      _AnimatedChatItemWidgetState();
}

class _AnimatedChatItemWidgetState extends State<_AnimatedChatItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getEmojiForName(String name) {
    switch (name.toLowerCase()) {
      case 'rumahai':
        return '🤖';
      case 'call center':
        return '🎧';
      default:
        return '💬';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFeccbdd), // Background Container Depan Chat
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  widget.avatar,
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(0xFF5a1d45), // Warna Nama Depan Chat
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getEmojiForName(widget.name),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.lastMessage,
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.time,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 231, 180, 180),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


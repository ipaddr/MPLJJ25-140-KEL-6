import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_akhir/providers/auth_provider.dart';
import 'package:project_akhir/screens/user/tabs/home_tab.dart';
import 'package:project_akhir/screens/user/tabs/assistance_tab.dart';
import 'package:project_akhir/screens/user/tabs/chat_tab.dart';
import 'package:project_akhir/screens/user/tabs/profile_tab.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _tabs = [
    const HomeTab(),
    const AssistanceTab(),
    const ChatTab(),
    const ProfileTab(),
  ];

  final List<String> _tabTitles = [
    'Rumah.ku',
    'Ajukan Bantuan',
    'Chatbox',
    'Profil'
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    if (authProvider.firebaseUser == null) {
      // If user is not logged in, show loading or redirect
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF8B0000),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Rumah.ku',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Ajukan Bantuan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
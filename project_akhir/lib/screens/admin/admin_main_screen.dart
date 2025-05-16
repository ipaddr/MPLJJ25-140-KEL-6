import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_akhir/providers/auth_provider.dart';
import 'package:project_akhir/screens/admin/tabs/requests_tab.dart';
import 'package:project_akhir/screens/admin/tabs/distribution_tab.dart';
import 'package:project_akhir/screens/admin/tabs/admin_profile_tab.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _tabs = [
    const RequestsTab(),
    const DistributionTab(),
    const AdminProfileTab(),
  ];

  final List<String> _tabTitles = [
    'Permintaan',
    'Penyaluran',
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
            icon: Icon(Icons.assignment),
            label: 'Permintaan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Penyaluran',
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
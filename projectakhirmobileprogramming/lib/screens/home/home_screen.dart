import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/sign-in');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome to the Home Screen!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Section for 'Rumah Bersanitasi Baik'
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Rumah Bersanitasi Baik',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 150, // Placeholder height
              color: Colors.grey[200], // Placeholder color
              child: const Center(
                child: Text('Placeholder for list of houses'),
              ),
            ),
            const SizedBox(height: 20),

            // Section for 'Berita Perumahan Terbaru'
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Berita Perumahan Terbaru',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 150, // Placeholder height
              color: Colors.grey[200], // Placeholder color
              child: const Center(
                child: Text('Placeholder for list of news'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
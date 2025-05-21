import 'package:flutter/material.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  // Placeholder data for demonstration
  final String adminName = 'Nama Admin';
  final String adminGender = 'Jenis Kelamin';
  final String adminNip = 'NIP Admin';
  final String adminStatusKepegawaian = 'Status Kepegawaian';
  final String adminTahunDiangkat = 'Tahun Diangkat';
  final String adminWilayahPenempatan = 'Wilayah Penempatan';
  final String adminGolongan = 'Golongan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Admin'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder for Cover Photo
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Text('Foto Beranda Placeholder', style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 16.0),

            // Placeholder for Profile Photo
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[400],
                child: const Icon(Icons.person, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16.0),

            // Admin Name and Gender
            Center(
              child: Column(
                children: [
                  Text(
                    adminName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    adminGender,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Employment Details
            Text(
              'Data Kepegawaian',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),

            _buildInfoRow('NIP:', adminNip),
            _buildInfoRow('Status Kepegawaian:', adminStatusKepegawaian),
            _buildInfoRow('Tahun Diangkat:', adminTahunDiangkat),
            _buildInfoRow('Wilayah Penempatan:', adminWilayahPenempatan),
            _buildInfoRow('Golongan:', adminGolongan),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
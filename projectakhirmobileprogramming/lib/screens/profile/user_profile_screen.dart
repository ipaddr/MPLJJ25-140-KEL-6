import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Placeholder controllers for input fields
  final TextEditingController _jumlahAnggotaKeluargaController = TextEditingController();
  final TextEditingController _statusPenerimaBantuanController = TextEditingController();
  final TextEditingController _statusHunianController = TextEditingController();
  final TextEditingController _tahunKepemilikanController = TextEditingController();
  final TextEditingController _statusKepemilikanController = TextEditingController();
  final TextEditingController _statusAirController = TextEditingController();
  final TextEditingController _statusKelembabanController = TextEditingController();
  final TextEditingController _statusLingkunganController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers
    _jumlahAnggotaKeluargaController.dispose();
    _statusPenerimaBantuanController.dispose();
    _statusHunianController.dispose();
    _tahunKepemilikanController.dispose();
    _statusKepemilikanController.dispose();
    _statusAirController.dispose();
    _statusKelembabanController.dispose();
    _statusLingkunganController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Placeholder for saving profile data
    print('Saving profile data...');
    print('Jumlah Anggota Keluarga: ${_jumlahAnggotaKeluargaController.text}');
    print('Status Penerima Bantuan: ${_statusPenerimaBantuanController.text}');
    print('Status Hunian: ${_statusHunianController.text}');
    print('Tahun Kepemilikan: ${_tahunKepemilikanController.text}');
    print('Status Kepemilikan: ${_statusKepemilikanController.text}');
    print('Status Air: ${_statusAirController.text}');
    print('Status Kelembaban: ${_statusKelembabanController.text}');
    print('Status Lingkungan: ${_statusLingkunganController.text}');
    // Implement actual data saving (e.g., to Firebase) here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Placeholder for Cover Photo
            Container(
              height: 150,
              color: Colors.grey[300],
              child: const Center(
                child: Text('Cover Photo Placeholder'),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                // Placeholder for Profile Photo
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[400],
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Nama Pengguna Placeholder',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Jenis Kelamin Placeholder',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Lengkapi Data Diri dan Hunian',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _jumlahAnggotaKeluargaController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Anggota Keluarga',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _statusPenerimaBantuanController,
              decoration: const InputDecoration(
                labelText: 'Status Penerima Bantuan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _statusHunianController,
              decoration: const InputDecoration(
                labelText: 'Status Hunian',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _tahunKepemilikanController,
              decoration: const InputDecoration(
                labelText: 'Tahun Kepemilikan',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _statusKepemilikanController,
              decoration: const InputDecoration(
                labelText: 'Status Kepemilikan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _statusAirController,
              decoration: const InputDecoration(
                labelText: 'Status Air',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _statusKelembabanController,
              decoration: const InputDecoration(
                labelText: 'Status Kelembaban',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _statusLingkunganController,
              decoration: const InputDecoration(
                labelText: 'Status Lingkungan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Simpan Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
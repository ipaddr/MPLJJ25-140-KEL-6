import 'package:flutter/material.dart';
import 'package:projectakhirmobileprogramming/screens/auth/admin_sign_in_screen.dart'; // Adjust the import path as needed

class AdminSignUpScreen extends StatefulWidget {
  const AdminSignUpScreen({Key? key}) : super(key: key);

  @override
  _AdminSignUpScreenState createState() => _AdminSignUpScreenState();
}

class _AdminSignUpScreenState extends State<AdminSignUpScreen> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();
  final TextEditingController _alamatEmailController = TextEditingController();
  final TextEditingController _statusKepegawaianController = TextEditingController();
  final TextEditingController _tahunDiangkatController = TextEditingController();
  final TextEditingController _wilayahPenempatanController = TextEditingController();
  final TextEditingController _golonganController = TextEditingController();
  final TextEditingController _kataSandiController = TextEditingController();

  @override
  void dispose() {
    _nipController.dispose();
    _namaLengkapController.dispose();
    _nomorTeleponController.dispose();
    _alamatEmailController.dispose();
    _statusKepegawaianController.dispose();
    _tahunDiangkatController.dispose();
    _wilayahPenempatanController.dispose();
    _golonganController.dispose();
    _kataSandiController.dispose();
    super.dispose();
  }

  void _buatAkun() {
    // Placeholder for account creation logic
    // For now, just navigate back to the sign-in screen
    Navigator.pop(context); // Or use Navigator.pushReplacementNamed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Admin'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nipController,
              decoration: const InputDecoration(labelText: 'NIP'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _namaLengkapController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _nomorTeleponController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _alamatEmailController,
              decoration: const InputDecoration(labelText: 'Alamat Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _statusKepegawaianController,
              decoration: const InputDecoration(labelText: 'Status Kepegawaian'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _tahunDiangkatController,
              decoration: const InputDecoration(labelText: 'Tahun Diangkat'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _wilayahPenempatanController,
              decoration: const InputDecoration(labelText: 'Wilayah Penempatan'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _golonganController,
              decoration: const InputDecoration(labelText: 'Golongan'),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _kataSandiController,
              decoration: const InputDecoration(labelText: 'Kata Sandi'),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _buatAkun,
              child: const Text('Buat Akun'),
            ),
          ],
        ),
      ),
    );
  }
}
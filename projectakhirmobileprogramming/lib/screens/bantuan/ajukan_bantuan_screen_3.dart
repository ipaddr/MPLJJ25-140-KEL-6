import 'package:flutter/material.dart';

class AjukanBantuanScreen3 extends StatefulWidget {
  const AjukanBantuanScreen3({Key? key}) : super(key: key);

  @override
  _AjukanBantuanScreen3State createState() => _AjukanBantuanScreen3State();
}

class _AjukanBantuanScreen3State extends State<AjukanBantuanScreen3> {
  final TextEditingController _tahunBangunanController = TextEditingController();
  final TextEditingController _statusKepemilikanController = TextEditingController();
  final TextEditingController _teganganListrikController = TextEditingController();
  final TextEditingController _statusPerairanController = TextEditingController();
  final TextEditingController _luasBangunanController = TextEditingController();
  final TextEditingController _luasTanahController = TextEditingController();
  final TextEditingController _tipeBangunanController = TextEditingController();

  @override
  void dispose() {
    _tahunBangunanController.dispose();
    _statusKepemilikanController.dispose();
    _teganganListrikController.dispose();
    _statusPerairanController.dispose();
    _luasBangunanController.dispose();
    _luasTanahController.dispose();
    _tipeBangunanController.dispose();
    super.dispose();
  }

  void _goToNextScreen() {
    // Placeholder for navigation to AjukanBantuanScreen4
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlaceholderScreen(title: 'Ajukan Bantuan 4')),
    );
  }

  void _goBack() {
    Navigator.pop(context);
  }

  // Placeholder for image upload functionality
  Widget _buildPhotoButton({required String label, VoidCallback? onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.upload_file),
      label: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Bantuan (Rumah)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tahunBangunanController,
              decoration: const InputDecoration(labelText: 'Tahun Bangunan'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _statusKepemilikanController,
              decoration: const InputDecoration(labelText: 'Status Kepemilikan'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _teganganListrikController,
              decoration: const InputDecoration(labelText: 'Tegangan Listrik (VA)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _statusPerairanController,
              decoration: const InputDecoration(labelText: 'Status Perairan'),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _luasBangunanController,
              decoration: const InputDecoration(labelText: 'Luas Bangunan (m²)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _luasTanahController,
              decoration: const InputDecoration(labelText: 'Luas Tanah (m²)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _tipeBangunanController,
              decoration: const InputDecoration(labelText: 'Tipe Bangunan'),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Lampiran Foto:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            _buildPhotoButton(label: 'Unggah Foto Tampak Depan'),
            const SizedBox(height: 12.0),
            _buildPhotoButton(label: 'Unggah Foto Tampak Belakang'),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _goToNextScreen,
              child: const Text('Selanjutnya'),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screen for navigation
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('This is a placeholder for $title'),
      ),
    );
  }
}
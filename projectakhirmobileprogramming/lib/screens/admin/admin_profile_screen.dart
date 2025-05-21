import 'package:flutter/material.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder data for demonstration
    final Map<String, dynamic> requestData = {
      'individual_data': {
        'nomorKeluarga': '1234567890123456',
        'nik': '9876543210987654',
        'namaLengkap': 'Budi Santoso',
        'tempatLahir': 'Jakarta',
        'tanggalLahir': '1990-05-15',
        'jenisKelamin': 'Laki-laki',
        'pekerjaan': 'Pegawai Swasta',
        'statusPerkawinan': 'Menikah',
        'provinsi': 'DKI Jakarta',
        'kabupatenKota': 'Jakarta Pusat',
        'kecamatan': 'Tanah Abang',
        'kelurahanDesa': 'Bendungan Hilir',
        'alamatKtp': 'Jl. Sudirman No. 123',
        'email': 'budi.santoso@example.com',
        'nomorTelepon': '081234567890',
      },
      'house_data': {
        'tahunBangunan': '2015',
        'statusKepemilikanRumah': 'Milik Sendiri',
        'teganganListrik': '1300 VA',
        'statusPerairan': 'PDAM',
        'luasBangunan': '70',
        'luasTanah': '100',
        'tipeBangunan': 'Permanen',
      },
      'house_photos': {
        'tampakDepanUrl': 'https://via.placeholder.com/300x200?text=Tampak+Depan',
        'tampakBelakangUrl': 'https://via.placeholder.com/300x200?text=Tampak+Belakang',
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Permintaan Bantuan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._buildIndividualData(requestData['individual_data'] ?? {}),
            const SizedBox(height: 24.0),
            ..._buildHouseData(requestData['house_data'] ?? {}),
            const SizedBox(height: 24.0),
            _buildHousePhotos(requestData['house_photos'] ?? {}),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIndividualData(Map<String, dynamic> data) {
    final fields = ['nomorKeluarga', 'nik', 'namaLengkap', 'tempatLahir', 'tanggalLahir', 'jenisKelamin', 'pekerjaan', 'statusPerkawinan', 'provinsi', 'kabupatenKota', 'kecamatan', 'kelurahanDesa', 'alamatKtp', 'email', 'nomorTelepon'];
    return fields.map((field) => _buildInfoRow(field, data[field] ?? 'N/A')).toList();
  }

  List<Widget> _buildHouseData(Map<String, dynamic> data) {
    final fields = ['tahunBangunan', 'statusKepemilikanRumah', 'teganganListrik', 'statusPerairan', 'luasBangunan', 'luasTanah', 'tipeBangunan'];
    return fields.map((field) => _buildInfoRow(field, data[field] ?? 'N/A')).toList();
  }

  Widget _buildHousePhotos(Map<String, dynamic> photos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhoto('Tampak Depan', photos['tampakDepanUrl']),
        const SizedBox(height: 16.0),
        _buildPhoto('Tampak Belakang', photos['tampakBelakangUrl']),
      ],
    );
  }

  Widget _buildPhoto(String label, String? url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        Center(
          child: url != null && url.isNotEmpty
              ? Image.network(
                  url,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Text('Gambar tidak dapat dimuat.'),
                )
              : const Text('Gambar tidak tersedia.'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
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

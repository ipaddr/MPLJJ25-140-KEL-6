import 'package:flutter/material.dart';

class AjukanBantuanScreen4 extends StatelessWidget {
  const AjukanBantuanScreen4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfirmasi Data Bantuan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke laman sebelumnya (Ajukan Bantuan 3)
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 60,
              ),
              SizedBox(height: 20),
              Text(
                'Penting: Pastikan Semua Data Terisi dengan Benar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Data yang Anda masukkan akan digunakan oleh admin untuk mengevaluasi kelayakan pengajuan bantuan. Ketidaksesuaian data dapat mempengaruhi proses penilaian.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              // Tombol untuk melanjutkan proses atau mengirim data bisa ditambahkan di sini
              // Namun sesuai permintaan, hanya fokus pada peringatan dan tombol kembali.
            ],
          ),
        ),
      ),
    );
  }
}
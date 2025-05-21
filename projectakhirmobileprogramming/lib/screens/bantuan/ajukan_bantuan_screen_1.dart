import 'package:flutter/material.dart';

class AjukanBantuanScreen1 extends StatelessWidget {
  const AjukanBantuanScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Bantuan'),
      ),
      body: const Center(
        child: Text('Tekan tombol \'Tambah Usulan\' untuk mengajukan bantuan.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the second assistance request screen (placeholder)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: const Text('Isi Data Bantuan'),
                ),
                body: const Center(
                  child: Text('Ini adalah laman untuk mengisi data bantuan (AjukanBantuanScreen2).'),
                ),
              ),
            ),
          );
        },
        tooltip: 'Tambah Usulan Bantuan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AjukanBantuanScreenRiwayat extends StatelessWidget {
  const AjukanBantuanScreenRiwayat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pengajuan Bantuan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const <Widget>[
          ListTile(
            title: Text('Usulan ke-1'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggal Pengajuan: 20 Oktober 2023'),
                Text('Status: Dipertimbangkan'),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Usulan ke-2'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggal Pengajuan: 15 September 2023'),
                Text('Status: Ditolak'),
              ],
            ),
          ),
          Divider(),
          // Add more placeholder items as needed
        ],
      ),
    );
  }
}
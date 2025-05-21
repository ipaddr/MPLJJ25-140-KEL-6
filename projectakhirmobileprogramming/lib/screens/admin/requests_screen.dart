import 'package:flutter/material.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permintaan Bantuan'),
      ),
      body: ListView.builder(
        itemCount: 5, // Placeholder: Display 5 sample requests
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Usulan ke-${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tanggal Diajukan: ${DateTime.now().toString().split(' ')[0]}'), // Placeholder date
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Placeholder: Handle Terima action
                        print('Usulan ke-${index + 1} Diterima');
                      },
                      child: const Text('Terima'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        // Placeholder: Handle Tolak action
                        print('Usulan ke-${index + 1} Ditolak');
                      },
                      child: const Text('Tolak'),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              // Placeholder: Navigate to detailed request view
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Detail Usulan ke-${index + 1}'),
                    ),
                    body: Center(
                      child: Text('Detail data untuk Usulan ke-${index + 1} akan ditampilkan di sini.'),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
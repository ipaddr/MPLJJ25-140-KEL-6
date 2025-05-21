import 'package:flutter/material.dart';

class DistributionScreen extends StatelessWidget {
  const DistributionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder data for approved requests
    final List<Map<String, String>> approvedRequests = [
      {
        'title': 'Usulan ke-1',
        'distributionDate': '15 November 2023',
      },
      {
        'title': 'Usulan ke-2',
        'distributionDate': '16 November 2023',
      },
      {
        'title': 'Usulan ke-3',
        'distributionDate': '17 November 2023',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penyaluran Bantuan'),
      ),
      body: ListView.builder(
        itemCount: approvedRequests.length,
        itemBuilder: (context, index) {
          final request = approvedRequests[index];
          return ListTile(
            title: Text(request['title']!),
            subtitle: Text('Tanggal Disalurkan: ${request['distributionDate']}'),
            // You might want to add onTap to view details if needed
            // onTap: () {
            //   // Navigate to detailed view if applicable
            // },
          );
        },
      ),
    );
  }
}
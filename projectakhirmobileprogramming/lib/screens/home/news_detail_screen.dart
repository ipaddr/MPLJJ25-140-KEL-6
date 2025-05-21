import 'package:flutter/material.dart';
import 'package:projectakhirmobileprogramming/models/news_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final News article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Karena article required dan non-nullable, tidak perlu cek null

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title ?? 'News Detail'),
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
            if (article.image != null && article.image!.isNotEmpty)
              Image.network(
                article.image!,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error); // Placeholder jika gagal load gambar
                },
              ),
            const SizedBox(height: 16.0),
            Text(
              article.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Source: ${article.source ?? 'Unknown Source'}',
              style: const TextStyle(
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Published Date Placeholder', // Ganti dengan properti tanggal jika ada
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              article.content ?? article.description ?? 'No Content Available',
              style: const TextStyle(fontSize: 16.0),
            ),
            if (article.author != null && article.author!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                'Author: ${article.author}',
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

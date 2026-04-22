import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/news.dart';

/// Detail screen for showing full news article
class DetailScreen extends StatelessWidget {
  final News news;

  const DetailScreen({super.key, required this.news});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết tin'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (news.imageUrl != null)
              Image.network(
                news.imageUrl!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 64),
                  );
                },
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 64),
              ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Meta info
                  Row(
                    children: [
                      if (news.author != null) ...[
                        Expanded(
                          child: Text(
                            'Tác giả: ${news.author}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                      Text(
                        dateFormat.format(news.pubDate),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    news.description,
                    style: const TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  // Read more button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(news.link),
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Đọc toàn bộ bài viết'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

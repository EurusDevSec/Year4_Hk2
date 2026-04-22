import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

/// Service for fetching and parsing RSS feeds from VnExpress
class RssService {
  static const Map<String, String> _rssUrls = {
    'Tổng hợp': 'https://vnexpress.net/rss/tin-moi-nhat.rss',
    'Thế giới': 'https://vnexpress.net/rss/the-gioi.rss',
    'Kinh doanh': 'https://vnexpress.net/rss/kinh-doanh.rss',
    'Công nghệ': 'https://vnexpress.net/rss/cong-nghe.rss',
    'Thể thao': 'https://vnexpress.net/rss/the-thao.rss',
    'Sức khỏe': 'https://vnexpress.net/rss/suc-khoe.rss',
  };

  // Mock data for testing
  static final List<Map<String, dynamic>> _mockNews = [
    {
      'title': 'Tin tức mẫu 1',
      'description': 'Đây là mô tả tin tức mẫu để test ứng dụng.',
      'link': 'https://vnexpress.net',
      'imageUrl': null,
      'pubDate': DateTime(2026, 4, 21, 10, 30),
      'author': 'VnExpress',
    },
    {
      'title': 'Tin tức mẫu 2',
      'description': 'Tin tức thứ hai cho kiểm tra giao diện.',
      'link': 'https://vnexpress.net',
      'imageUrl': null,
      'pubDate': DateTime(2026, 4, 21, 9, 15),
      'author': 'VnExpress',
    },
    {
      'title': 'Tin tức mẫu 3',
      'description': 'Tin tức thứ ba hiển thị danh sách tin tức.',
      'link': 'https://vnexpress.net',
      'imageUrl': null,
      'pubDate': DateTime(2026, 4, 21, 8, 0),
      'author': 'VnExpress',
    },
  ];

  /// Get all available categories
  static List<String> getCategories() {
    return _rssUrls.keys.toList();
  }

  /// Fetch RSS feed for a specific category
  static Future<List<Map<String, dynamic>>> fetchRssFeed(
    String category,
  ) async {
    try {
      final url = _rssUrls[category];
      if (url == null) {
        return _getMockNews();
      }

      try {
        final response = await http
            .get(Uri.parse(url))
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw Exception('Request timeout');
              },
            );

        if (response.statusCode == 200) {
          // Clean BOM if exists
          String body = response.body;
          if (body.startsWith('\u{FEFF}')) {
            body = body.substring(1);
          }

          try {
            return _parseRssFeed(body);
          } catch (parseError) {
            // If parsing fails, return mock data
            print('RSS Parse Error: $parseError');
            return _getMockNews();
          }
        } else {
          return _getMockNews();
        }
      } catch (networkError) {
        // If network fails, return mock data
        print('Network Error: $networkError');
        return _getMockNews();
      }
    } catch (e) {
      print('Unexpected Error: $e');
      return _getMockNews();
    }
  }

  /// Get mock news data for testing
  static List<Map<String, dynamic>> _getMockNews() {
    return _mockNews
        .map(
          (item) => {
            'title': item['title'] as String,
            'description': item['description'] as String,
            'link': item['link'] as String,
            'imageUrl': item['imageUrl'] as String?,
            'pubDate': item['pubDate'] as DateTime,
            'author': item['author'] as String,
          },
        )
        .toList();
  }

  /// Parse RSS feed XML and extract items
  static List<Map<String, dynamic>> _parseRssFeed(String xmlString) {
    try {
      // Validate XML is not empty
      if (xmlString.trim().isEmpty) {
        return _getMockNews();
      }

      // Check if response is XML
      if (!xmlString.trim().startsWith('<')) {
        return _getMockNews();
      }

      final document = xml.XmlDocument.parse(xmlString);
      final items = document.findAllElements('item');

      // If no items found, return mock data
      if (items.isEmpty) {
        return _getMockNews();
      }

      final newsList = <Map<String, dynamic>>[];

      for (var item in items) {
        try {
          final title = item.findElements('title').firstOrNull?.innerText ?? '';
          final description =
              item.findElements('description').firstOrNull?.innerText ?? '';
          final link = item.findElements('link').firstOrNull?.innerText ?? '';
          final pubDateStr =
              item.findElements('pubDate').firstOrNull?.innerText ?? '';
          final author =
              item.findElements('author').firstOrNull?.innerText ?? '';

          // Skip if no title or link
          if (title.isEmpty && link.isEmpty) {
            continue;
          }

          // Extract image URL from description (VnExpress includes img tag in description)
          final imageUrl = _extractImageUrl(description);

          // Clean description (remove HTML tags)
          final cleanDescription = _stripHtmlTags(description);

          // Parse publication date
          DateTime pubDate;
          try {
            pubDate = _parseRssDate(pubDateStr);
          } catch (e) {
            pubDate = DateTime.now();
          }

          newsList.add({
            'title': title,
            'description': cleanDescription,
            'link': link,
            'imageUrl': imageUrl,
            'pubDate': pubDate,
            'author': author,
          });
        } catch (e) {
          // Skip items with parsing errors
          print('Item parse error: $e');
          continue;
        }
      }

      // Return mock data if no valid items parsed
      return newsList.isEmpty ? _getMockNews() : newsList;
    } catch (e) {
      print('XML Parse Error: $e');
      return _getMockNews();
    }
  }

  /// Extract image URL from HTML description
  static String? _extractImageUrl(String html) {
    try {
      // Find the first src attribute (usually the image in VnExpress RSS description)
      final regex = RegExp(r'''src=["']([^"']+)["']''', caseSensitive: false);
      final match = regex.firstMatch(html);
      return match?.group(1);
    } catch (e) {
      return null;
    }
  }

  /// Remove HTML tags from text
  static String _stripHtmlTags(String html) {
    // Remove script and style tags
    html = html.replaceAll(
      RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false),
      '',
    );
    html = html.replaceAll(
      RegExp(r'<style[^>]*>.*?</style>', caseSensitive: false),
      '',
    );

    // Remove HTML tags
    html = html.replaceAll(RegExp(r'<[^>]+>'), '');

    // Decode HTML entities
    html = _decodeHtmlEntities(html);

    // Trim whitespace
    html = html.trim();

    return html;
  }

  /// Decode common HTML entities
  static String _decodeHtmlEntities(String html) {
    html = html.replaceAll('&nbsp;', ' ');
    html = html.replaceAll('&lt;', '<');
    html = html.replaceAll('&gt;', '>');
    html = html.replaceAll('&amp;', '&');
    html = html.replaceAll('&quot;', '"');
    html = html.replaceAll('&#039;', "'");
    return html;
  }

  /// Parse RSS date format (RFC 2822)
  static DateTime _parseRssDate(String dateStr) {
    try {
      // RFC 2822 format: "Mon, 21 Apr 2026 10:30:00 +0700"
      return DateTime.parse(dateStr);
    } catch (e) {
      try {
        // Fallback: try parsing without timezone
        final parts = dateStr.split(' ');
        if (parts.length >= 4) {
          final cleanDate = '${parts[3]} ${parts[2]} ${parts[1]} ${parts[0]}';
          return DateTime.parse(cleanDate);
        }
      } catch (e) {
        // Last resort: return current time
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}
